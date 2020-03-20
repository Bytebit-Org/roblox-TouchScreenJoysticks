import { Joystick } from "../Implementation/Joystick";
import { Players, UserInputService } from "@rbxts/services";

export class JoysticksManagerSingleton {
    // A sorted array of the registered joysticks in ascending order of priority
    private joysticks: ReadonlyArray<Joystick>;

    private readonly inactiveGuttersScreenGui: ScreenGui;
    private readonly inactiveThumbsScreenGui: ScreenGui;
    private readonly activeGuttersScreenGui: ScreenGui;
    private readonly activeThumbsScreenGui: ScreenGui;

    private readonly activeJoysticksByTouchInputObject: Map<InputObject, Joystick>;
    private readonly touchInputObjectsByActiveJoystick: Map<Joystick, InputObject>;

    public constructor() {
        this.joysticks = new Array<Joystick>();

        this.inactiveGuttersScreenGui = this.createScreenGui(1, "Joysticks_InactiveGutters");
        this.inactiveThumbsScreenGui = this.createScreenGui(2, "Joysticks_InactiveThumbs");
        this.activeGuttersScreenGui = this.createScreenGui(3, "Joysticks_ActiveGutters");
        this.activeThumbsScreenGui = this.createScreenGui(4, "Joysticks_ActiveThumbs");

        this.activeJoysticksByTouchInputObject = new Map<InputObject, Joystick>();
        this.touchInputObjectsByActiveJoystick = new Map<Joystick, InputObject>();

        this.listenForTouchEvents();
    }

    // Internal instance methods

    public deregisterJoystick(oldJoystick: Joystick) {
        const newArray = new Array<Joystick>();
        
        for (const existingJoystick of this.joysticks) {
            if (existingJoystick !== oldJoystick) {
                newArray.push(existingJoystick);
            }
        }

        const activeTouchInputObject = this.touchInputObjectsByActiveJoystick.get(oldJoystick);
        if (activeTouchInputObject !== undefined) {
            this.activeJoysticksByTouchInputObject.delete(activeTouchInputObject);
            this.touchInputObjectsByActiveJoystick.delete(oldJoystick);
        }

        this.joysticks = newArray;
    }

    public requestRender(joystick: Joystick) {
        // TODO: Consider setting up some sort of event based system using RunService
        this.renderJoystick(joystick);
    }

    public registerJoystick(newJoystick: Joystick) {
        const newArray = new Array<Joystick>();
        
        let hasNewJoystickBeenAddedYet = false;
        for (const existingJoystick of this.joysticks) {
            if (!existingJoystick.isEnabled || !existingJoystick.isVisible) {
                continue;
            }
            
            if (!hasNewJoystickBeenAddedYet && newJoystick.priorityLevel < existingJoystick.priorityLevel) {
                newArray.push(newJoystick);
                hasNewJoystickBeenAddedYet = true;
            }

            newArray.push(existingJoystick);
        }

        if (!hasNewJoystickBeenAddedYet) {
            newArray.push(newJoystick);
        }

        this.joysticks = newArray;
    }

    // Private instance methods

    private createScreenGui(displayOrder: number, name: string) {
        const screenGui = new Instance("ScreenGui");
        screenGui.DisplayOrder = 1;
        screenGui.Name = name;
        screenGui.ResetOnSpawn = false;
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

        screenGui.Parent = Players.LocalPlayer.WaitForChild("PlayerGui");

        return screenGui;
    }

    private listenForTouchEvents() {
        UserInputService.TouchStarted.Connect((inputObject, didGameProcessEvent) => {
            if (didGameProcessEvent) {
                return;
            }

            const inputPoint = new Vector2(inputObject.Position.X, inputObject.Position.Y);

            for (let i = this.joysticks.size() - 1; i >= 0; i--) {
                const joystick = this.joysticks[i];
                if (joystick.activationRegion.isPointInRegion(inputPoint)) {
                    if (joystick.isActive) {
                        return;
                    }

                    this.activeJoysticksByTouchInputObject.set(inputObject, joystick);
                    this.touchInputObjectsByActiveJoystick.set(joystick, inputObject);

                    joystick.activate(inputPoint);
                    this.renderJoystick(joystick);
                }
            }
        });

        UserInputService.TouchMoved.Connect(inputObject => {
            const activeJoystick = this.activeJoysticksByTouchInputObject.get(inputObject);
            if (activeJoystick === undefined) {
                return;
            }

            const inputPoint = new Vector2(inputObject.Position.X, inputObject.Position.Y);
            activeJoystick.updateInput(inputPoint);
            this.renderJoystick(activeJoystick);
        });

        UserInputService.TouchEnded.Connect(inputObject => {
            const activeJoystick = this.activeJoysticksByTouchInputObject.get(inputObject);
            if (activeJoystick === undefined) {
                return;
            }

            this.activeJoysticksByTouchInputObject.delete(inputObject);
            this.touchInputObjectsByActiveJoystick.delete(activeJoystick);

            activeJoystick.deactivate();
            this.renderJoystick(activeJoystick);
        });
    }

    private renderJoystick(joystick: Joystick) {
        if (joystick.isActive) {
            joystick.render(this.activeGuttersScreenGui, this.activeThumbsScreenGui);
        } else {
            joystick.render(this.inactiveGuttersScreenGui, this.inactiveThumbsScreenGui);
        }
    }
}

export const JoysticksManager = new JoysticksManagerSingleton();