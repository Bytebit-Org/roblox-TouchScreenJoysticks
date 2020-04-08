import { Joystick } from "../Internal/Joystick";
import { Players, UserInputService, GuiService, Workspace } from "@rbxts/services";
import { IJoysticksManager } from "../Interfaces/IJoysticksManager";
import { IJoystickConfiguration } from "../Interfaces/IJoystickConfiguration";
import { IJoystick } from "../Interfaces/IJoystick";
import { Dumpster } from "@rbxts/dumpster";
import { IJoystickInputCalculator } from "../Interfaces/IJoystickInputCalculator";
import { JoystickInputCalculator } from "../Internal/JoystickInputCalculator";

export class JoysticksManager implements IJoysticksManager {
	/** A sorted array of the registered joysticks in ascending order of priority */
	private sortedJoysticksArray: ReadonlyArray<Joystick>;
	private joysticksSet: Set<IJoystick>;

	private readonly activeJoysticksScreenGui: ScreenGui;
	private readonly inactiveJoysticksScreenGui: ScreenGui;

	private readonly activeJoysticksByTouchInputObject: Map<InputObject, Joystick>;
	private readonly touchInputObjectsByActiveJoystick: Map<IJoystick, InputObject>;

	private readonly dumpster: Dumpster;
	private isDestroyed = false;

	// Dependencies
	private readonly joystickInstantiator: (
		configuration: IJoystickConfiguration,
		joysticksManager: JoysticksManager,
	) => Joystick;
	private readonly screenGuiParent: Instance;
	private readonly userInputService: UserInputService;

	/** Use the create method instead! */
	private constructor(
		joystickInstantiator: (configuration: IJoystickConfiguration, joysticksManager: JoysticksManager) => Joystick,
		screenGuiParent: Instance,
		userInputService: UserInputService,
	) {
		this.joystickInstantiator = joystickInstantiator;
		this.screenGuiParent = screenGuiParent;
		this.userInputService = userInputService;

		this.sortedJoysticksArray = new Array<Joystick>();
		this.joysticksSet = new Set<IJoystick>();

		this.activeJoysticksScreenGui = this.createScreenGui(2, "Joysticks_ActiveJoysticks");
		this.inactiveJoysticksScreenGui = this.createScreenGui(1, "Joysticks_InactiveJoysticks");

		this.activeJoysticksByTouchInputObject = new Map<InputObject, Joystick>();
		this.touchInputObjectsByActiveJoystick = new Map<IJoystick, InputObject>();

		this.dumpster = new Dumpster();

		this.dumpster.dump(this.activeJoysticksScreenGui);
		this.dumpster.dump(this.inactiveJoysticksScreenGui);

		this.listenForTouchEvents();
	}

	/** Creates a new instance */
	public static create(): IJoysticksManager {
		const playerGui = Players.LocalPlayer.WaitForChild("PlayerGui");
		return new JoysticksManager(
			(joystickConfiguration, joysticksManager) =>
				new Joystick(
					joystickConfiguration,
					() => Workspace.CurrentCamera,
					GuiService,
					new JoystickInputCalculator(),
					joysticksManager,
				),
			playerGui,
			UserInputService,
		);
	}

	// Public instance methods

	public createJoystick(joystickConfiguration: IJoystickConfiguration) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		const newJoystick = this.joystickInstantiator(joystickConfiguration, this);

		this.registerJoystick(newJoystick);

		if (newJoystick.isVisible) {
			this.renderJoystick(newJoystick);
		}

		return newJoystick;
	}

	public destroy() {
		this.isDestroyed = true;

		for (const key of Object.keys(this.activeJoysticksByTouchInputObject)) {
			// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
			const activeJoystick = this.activeJoysticksByTouchInputObject.get(key)!;
			activeJoystick.deactivate();

			this.activeJoysticksByTouchInputObject.delete(key);
			this.touchInputObjectsByActiveJoystick.delete(activeJoystick);
		}

		this.dumpster.burn();
	}

	// Internal instance methods

	public deregisterJoystick(oldJoystick: IJoystick) {
		const newArray = new Array<Joystick>();

		for (const existingJoystick of this.sortedJoysticksArray) {
			if (existingJoystick !== oldJoystick) {
				newArray.push(existingJoystick);
			}
		}

		const activeTouchInputObject = this.touchInputObjectsByActiveJoystick.get(oldJoystick);
		if (activeTouchInputObject !== undefined) {
			this.activeJoysticksByTouchInputObject.delete(activeTouchInputObject);
			this.touchInputObjectsByActiveJoystick.delete(oldJoystick);
		}

		this.sortedJoysticksArray = newArray;

		this.joysticksSet.delete(oldJoystick);
	}

	public requestRender(joystick: Joystick) {
		// TODO: Consider setting up some sort of event based system using RunService
		this.renderJoystick(joystick);
	}

	// Private instance methods

	private createScreenGui(displayOrder: number, name: string) {
		const screenGui = new Instance("ScreenGui");
		screenGui.DisplayOrder = displayOrder;
		screenGui.Name = name;
		screenGui.ResetOnSpawn = false;
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

		screenGui.Parent = this.screenGuiParent;

		return screenGui;
	}

	private listenForTouchEvents() {
		this.dumpster.dump(
			this.userInputService.TouchStarted.Connect((inputObject, didGameProcessEvent) => {
				if (didGameProcessEvent) {
					return;
				}

				const inputPoint = new Vector2(inputObject.Position.X, inputObject.Position.Y);

				for (let i = this.sortedJoysticksArray.size() - 1; i >= 0; i--) {
					const joystick = this.sortedJoysticksArray[i];
					if (joystick.isEnabled && joystick.activationRegion.isPointInRegion(inputPoint)) {
						if (joystick.isActive) {
							return;
						}

						this.activeJoysticksByTouchInputObject.set(inputObject, joystick);
						this.touchInputObjectsByActiveJoystick.set(joystick, inputObject);

						joystick.activate(inputPoint);
						this.renderJoystick(joystick);

						break;
					}
				}
			}),
		);

		this.dumpster.dump(
			this.userInputService.TouchMoved.Connect(inputObject => {
				const activeJoystick = this.activeJoysticksByTouchInputObject.get(inputObject);
				if (activeJoystick === undefined) {
					return;
				}

				const inputPoint = new Vector2(inputObject.Position.X, inputObject.Position.Y);
				activeJoystick.updateInput(inputPoint);
				this.renderJoystick(activeJoystick);
			}),
		);

		this.dumpster.dump(
			this.userInputService.TouchEnded.Connect(inputObject => {
				const activeJoystick = this.activeJoysticksByTouchInputObject.get(inputObject);
				if (activeJoystick === undefined) {
					return;
				}

				this.activeJoysticksByTouchInputObject.delete(inputObject);
				this.touchInputObjectsByActiveJoystick.delete(activeJoystick);

				activeJoystick.deactivate();
				this.renderJoystick(activeJoystick);
			}),
		);
	}

	private registerJoystick(newJoystick: Joystick) {
		const newArray = new Array<Joystick>();

		let hasNewJoystickBeenAddedYet = false;
		for (const existingJoystick of this.sortedJoysticksArray) {
			if (!hasNewJoystickBeenAddedYet && newJoystick.priorityLevel < existingJoystick.priorityLevel) {
				newArray.push(newJoystick);
				hasNewJoystickBeenAddedYet = true;
			}

			newArray.push(existingJoystick);
		}

		if (!hasNewJoystickBeenAddedYet) {
			newArray.push(newJoystick);
		}

		this.sortedJoysticksArray = newArray;

		this.joysticksSet.add(newJoystick);
	}

	private renderJoystick(joystick: Joystick) {
		if (joystick.isActive) {
			joystick.render(this.activeJoysticksScreenGui);
		} else {
			joystick.render(this.inactiveJoysticksScreenGui);
		}
	}
}
