import { IJoystickConfiguration } from "../Interfaces/IJoystickConfiguration";
import { IJoystick } from "../Interfaces/IJoystick";
import { ISignal, Signal } from "@rbxts/signals-tooling";
import { IGuiWindowRegion } from "../Interfaces/IGuiWindowRegion";
import { IJoystickRenderer } from "../Interfaces/IJoystickRenderer";
import { Dumpster } from "@rbxts/dumpster";
import { JoysticksManager } from "../Implementation/JoysticksManager";
import { IJoystickInputCalculator } from "../Interfaces/IJoystickInputCalculator";

export class Joystick implements IJoystick {
	// Public instance members
	public input?: Vector2;
	public isActive: boolean;
	public isEnabled: boolean;
	public isVisible: boolean;
	public priorityLevel: number;

	// Public instance signals
	public activated: ISignal<(initialInput: Vector2) => void>;
	public deactivated: ISignal<(finalInput: Vector2) => void>;
	public disabled: ISignal;
	public enabled: ISignal;
	public inputChanged: ISignal<(newInput: Vector2) => void>;
	public visibilityChanged: ISignal<(newValue: boolean) => void>;

	// Internal instance members
	public activationRegion: IGuiWindowRegion;

	// Private instance members
	private gutterCenterPoint: Vector2;
	private gutterRadiusInPixels: number;
	private inactiveCenterPoint: Vector2;
	private isDestroyed = false;
	private relativeThumbRadius: number;
	private renderer: IJoystickRenderer;
	private signalsDumpster: Dumpster;
	private shouldMoveCenterPointWhenActivated: boolean;

	// Dependencies
	private readonly currentCameraGetter: () => Camera | undefined;
	private readonly guiService: GuiService;
	private readonly joysticksManager: JoysticksManager;
	private readonly joystickInputCalculator: IJoystickInputCalculator;

	/** Meant for internal-use only! */
	public constructor(
		configuration: IJoystickConfiguration,
		currentCameraGetter: () => Camera | undefined,
		guiService: GuiService,
		joystickInputCalculator: IJoystickInputCalculator,
		joysticksManager: JoysticksManager,
	) {
		// Initialize public instance members
		this.isActive = false;
		this.isEnabled = configuration.initializedEnabled !== undefined ? configuration.initializedEnabled : false;
		this.isVisible = configuration.initializedVisible !== undefined ? configuration.initializedVisible : false;
		this.priorityLevel = configuration.priorityLevel !== undefined ? configuration.priorityLevel : 1;

		// Initialize public instance signals
		this.activated = new Signal<(initialInput: Vector2) => void>();
		this.deactivated = new Signal<(finalInput: Vector2) => void>();
		this.disabled = new Signal();
		this.enabled = new Signal();
		this.inputChanged = new Signal<(newInput: Vector2) => void>();
		this.visibilityChanged = new Signal<(newValue: boolean) => void>();

		// Initialize private instance members from configuration
		this.activationRegion = configuration.activationRegion;
		this.gutterCenterPoint = configuration.inactiveCenterPoint;
		this.gutterRadiusInPixels = configuration.gutterRadiusInPixels;
		this.inactiveCenterPoint = configuration.inactiveCenterPoint;
		this.relativeThumbRadius = configuration.relativeThumbRadius;
		this.renderer = configuration.renderer;
		this.shouldMoveCenterPointWhenActivated = configuration.shouldMoveCenterPointWhenActivated ?? true;

		// Initialize other private members
		this.signalsDumpster = new Dumpster();

		// Fill in dependencies
		this.currentCameraGetter = currentCameraGetter;
		this.guiService = guiService;
		this.joysticksManager = joysticksManager;
		this.joystickInputCalculator = joystickInputCalculator;

		// Dump things
		this.signalsDumpster.dump(this.activated, signal => signal.disconnectAll());
		this.signalsDumpster.dump(this.deactivated, signal => signal.disconnectAll());
		this.signalsDumpster.dump(this.disabled, signal => signal.disconnectAll());
		this.signalsDumpster.dump(this.enabled, signal => signal.disconnectAll());
		this.signalsDumpster.dump(this.inputChanged, signal => signal.disconnectAll());
		this.signalsDumpster.dump(this.visibilityChanged, signal => signal.disconnectAll());
	}

	// Public instance methods
	public destroy() {
		if (this.isActive) {
			this.deactivate();
		}

		this.isDestroyed = true;

		this.signalsDumpster.burn();
		this.renderer.destroy();

		this.joysticksManager.deregisterJoystick(this);
	}

	public setActivationRegion(newRegion: IGuiWindowRegion) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.activationRegion = newRegion;
	}

	public setEnabled(newValue: boolean) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		if (newValue !== this.isEnabled) {
			this.isEnabled = newValue;

			if (newValue) {
				this.enabled.fire();
			} else {
				this.disabled.fire();
				if (this.isActive) {
					this.deactivate();
				}
			}
		}
	}

	public setGutterRadiusInPixels(newRadiusInPixels: number) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.gutterRadiusInPixels = newRadiusInPixels;

		this.joysticksManager.requestRender(this);
	}

	public setInactiveCenterPoint(newPoint: Vector2) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.inactiveCenterPoint = newPoint;

		if (!this.isActive) {
			this.gutterCenterPoint = newPoint;
			this.joysticksManager.requestRender(this);
		}
	}

	public setPriorityLevel(newPriorityLevel: number) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.priorityLevel = newPriorityLevel;

		this.joysticksManager.requestRender(this);
	}

	public setRelativeThumbRadius(relativeThumbRadius: number) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.relativeThumbRadius = relativeThumbRadius;

		this.joysticksManager.requestRender(this);
	}

	public setRenderer(newRenderer: IJoystickRenderer) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.renderer.destroy();
		this.renderer = newRenderer;

		this.joysticksManager.requestRender(this);
	}

	public setVisible(newValue: boolean): void {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		if (this.isVisible !== newValue) {
			this.isVisible = newValue;

			if (newValue) {
				this.joysticksManager.requestRender(this);
			} else {
				this.renderer.hide();
				if (this.isActive) {
					this.deactivate();
				}
			}

			this.visibilityChanged.fire(newValue);
		}
	}

	// Internal instance methods
	public activate(inputPoint: Vector2): void {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		if (this.isActive) {
			return;
		}

		const guiWindowSize = this.getGuiWindowSize();

		if (this.shouldMoveCenterPointWhenActivated) {
			let newGutterCenter = inputPoint;

			if (inputPoint.X - this.gutterRadiusInPixels < 0) {
				newGutterCenter = new Vector2(this.gutterRadiusInPixels, newGutterCenter.Y);
			} else if (inputPoint.X + this.gutterRadiusInPixels > guiWindowSize.X) {
				newGutterCenter = new Vector2(guiWindowSize.X - this.gutterRadiusInPixels, newGutterCenter.Y);
			}

			if (inputPoint.Y - this.gutterRadiusInPixels < 0) {
				newGutterCenter = new Vector2(newGutterCenter.X, this.gutterRadiusInPixels);
			} else if (inputPoint.Y + this.gutterRadiusInPixels > guiWindowSize.Y) {
				newGutterCenter = new Vector2(newGutterCenter.X, guiWindowSize.Y - this.gutterRadiusInPixels);
			}

			this.gutterCenterPoint = newGutterCenter;
		}

		const initialInput = this.joystickInputCalculator.calculate(
			this.gutterCenterPoint,
			this.gutterRadiusInPixels,
			this.relativeThumbRadius,
			inputPoint,
		);

		this.input = initialInput;
		this.isActive = true;

		this.activated.fire(initialInput);
	}

	public deactivate(): void {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		if (!this.isActive || this.input === undefined) {
			return;
		}

		this.gutterCenterPoint = this.inactiveCenterPoint;

		const finalInput = this.input;

		this.input = undefined;
		this.isActive = false;

		this.deactivated.fire(finalInput);
	}

	public render(screenGui: ScreenGui): void {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		const relativeThumbPosition =
			this.input !== undefined ? this.input.mul(1 - this.relativeThumbRadius) : new Vector2(0, 0);
		this.renderer.render(
			this.gutterCenterPoint,
			relativeThumbPosition,
			this.gutterRadiusInPixels,
			this.relativeThumbRadius,
			this.priorityLevel,
			screenGui,
		);
	}

	public updateInput(inputPoint: Vector2): void {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		if (!this.isActive) {
			throw `Cannot update an inactive instance's input`;
		}

		const newInput = this.joystickInputCalculator.calculate(
			this.gutterCenterPoint,
			this.gutterRadiusInPixels,
			this.relativeThumbRadius,
			inputPoint,
		);

		this.input = newInput;
		this.inputChanged.fire(newInput);
	}

	// Private instance methods
	private getGuiWindowSize(): Vector2 {
		const currentCamera = this.currentCameraGetter();
		if (currentCamera === undefined) {
			throw `Cannot get guiWindow size because Workspace.CurrentCamera is undefined`;
		}

		const [guiInsetTopLeft, guiInsetBottomRight] = this.guiService.GetGuiInset();
		const guiWindowTopLeft = guiInsetTopLeft;
		const guiWindowBottomRight = currentCamera.ViewportSize.sub(guiInsetBottomRight);
		const guiWindowSize = guiWindowBottomRight.sub(guiWindowTopLeft);

		return guiWindowSize;
	}
}
