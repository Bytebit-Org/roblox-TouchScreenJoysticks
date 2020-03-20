import { IJoystickConfiguration } from "../Interfaces/IJoystickConfiguration";
import { IJoystick } from "../Interfaces/IJoystick";
import { ISignal, Signal } from "@rbxts/signals-tooling";
import { IViewportRegion } from "../Interfaces/IViewportRegion";
import { IRenderer } from "../Interfaces/IRenderer";
import { Dumpster } from "@rbxts/dumpster";
import { JoysticksManager } from "../Internal/JoysticksManager";
import { Workspace, GuiService } from "@rbxts/services";

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
    public activationRegion: IViewportRegion;

    // Private instance members
    private gutterCenterPoint: Vector2;
    private gutterRadiusInPixels: number;
    private gutterRenderer: IRenderer;
    private inactiveCenterPoint: Vector2;
    private isDestroyed = false;
    private signalsDumpster: Dumpster;
    private thumbRadiusInPixels: number;
    private thumbRenderer: IRenderer;

    private constructor(configuration: IJoystickConfiguration) {
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
        this.gutterRadiusInPixels = configuration.gutterRadiusInPixels;
        this.gutterRenderer = configuration.gutterRenderer;
        this.inactiveCenterPoint = configuration.inactiveCenterPoint;
        this.thumbRadiusInPixels = configuration.thumbRadiusInPixels;
        this.thumbRenderer = configuration.thumbRenderer;

        // Initialize other private members
        this.gutterCenterPoint = configuration.inactiveCenterPoint;
        this.signalsDumpster = new Dumpster();

        // Dump things
        this.signalsDumpster.dump(this.activated, signal => signal.disconnectAll());
        this.signalsDumpster.dump(this.deactivated, signal => signal.disconnectAll());
        this.signalsDumpster.dump(this.disabled, signal => signal.disconnectAll());
        this.signalsDumpster.dump(this.enabled, signal => signal.disconnectAll());
        this.signalsDumpster.dump(this.inputChanged, signal => signal.disconnectAll());
        this.signalsDumpster.dump(this.visibilityChanged, signal => signal.disconnectAll());

        // Register to start listening for inputs
        JoysticksManager.registerJoystick(this);

        // Render if necessary
        if (this.isVisible) {
            JoysticksManager.requestRender(this);
        }
    }

    /**
     * Creates a new instance
     * @param configuration An `IJoystickConfiguration` that defines the configuration parameters for the new `IJoystick` instance
     * @returns The new instance
     */
    public static create(configuration: IJoystickConfiguration): IJoystick {
        return new Joystick(configuration);
    }

    // Public instance methods
    public destroy() {
        this.isDestroyed = true;

        this.signalsDumpster.burn();
        this.gutterRenderer.destroy();
        this.thumbRenderer.destroy();

        JoysticksManager.deregisterJoystick(this);
    }

    public setActivationRegion(newRegion: IViewportRegion) {
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
            }
        }
    }

    public setGutterRadiusInPixels(newRadiusInPixels: number) {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        this.gutterRadiusInPixels = newRadiusInPixels;

        JoysticksManager.requestRender(this);
    }

    public setGutterRenderer(newRenderer: IRenderer) {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        this.gutterRenderer.destroy();
        this.gutterRenderer = newRenderer;

        JoysticksManager.requestRender(this);
    }

    public setInactiveCenterPoint(newPoint: Vector2) {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        this.inactiveCenterPoint = newPoint;

        if (!this.isActive) {
            JoysticksManager.requestRender(this);
        }
    }

    public setPriorityLevel(newPriorityLevel: number) {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        this.priorityLevel = newPriorityLevel;

        JoysticksManager.requestRender(this);
    }

    public setThumbRadiusInPixels(newRadiusInPixels: number) {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        this.thumbRadiusInPixels = newRadiusInPixels;

        JoysticksManager.requestRender(this);
    }

    public setThumbRenderer(newRenderer: IRenderer) {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        this.thumbRenderer.destroy();
        this.thumbRenderer = newRenderer;

        JoysticksManager.requestRender(this);
    }

    public setVisible(newValue: boolean): void {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        if (this.isVisible !== newValue) {
            this.isVisible = newValue;

            if (newValue) {
                this.gutterRenderer.hide();
                this.thumbRenderer.hide();
            } else {
                JoysticksManager.requestRender(this);
            }

            this.visibilityChanged.fire(newValue);
        }
    }

    // Internal instance methods
    public activate(inputPoint: Vector2): void {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        const viewportSize = this.getViewportSize();

        let newGutterCenter = inputPoint;

        if (inputPoint.X - this.gutterRadiusInPixels < 0) {
            newGutterCenter = new Vector2(this.gutterRadiusInPixels, newGutterCenter.Y);
        } else if (inputPoint.X + this.gutterRadiusInPixels > viewportSize.X) {
            newGutterCenter = new Vector2(viewportSize.X - this.gutterRadiusInPixels, newGutterCenter.Y);
        }

        if (inputPoint.Y - this.gutterRadiusInPixels < 0) {
            newGutterCenter = new Vector2(newGutterCenter.X, this.gutterRadiusInPixels);
        } else if (inputPoint.Y + this.gutterRadiusInPixels > viewportSize.Y) {
            newGutterCenter = new Vector2(newGutterCenter.X, viewportSize.Y - this.gutterRadiusInPixels);
        }

        this.gutterCenterPoint = newGutterCenter;

        const initialInput =  this.calculateInput(inputPoint);
        
        this.input = initialInput;
        this.isActive = true;

        this.activated.fire(initialInput);
    }

    public deactivate(): void {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        this.gutterCenterPoint = this.inactiveCenterPoint;

        const finalInput = this.input!;

        this.input = undefined;
        this.isActive = false;

        this.activated.fire(finalInput);
    }

    public render(gutterScreenGui: ScreenGui, thumbScreenGui: ScreenGui): void {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        const effectiveGutterRadius = this.calculateEffectiveGutterRadius();
        const thumbCenterPoint = this.input !== undefined ? this.gutterCenterPoint.add(this.input.mul(effectiveGutterRadius)) : this.gutterCenterPoint;

        this.gutterRenderer.render(this.gutterCenterPoint, this.gutterRadiusInPixels, this.priorityLevel, gutterScreenGui);
        this.thumbRenderer.render(thumbCenterPoint, this.thumbRadiusInPixels, this.priorityLevel, thumbScreenGui);
    }

    public updateInput(inputPoint: Vector2): void {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        if (!this.isActive) {
            throw `Cannot update an inactive instance's input`;
        }
        
        const newInput = this.calculateInput(inputPoint);

        this.input = newInput;
        this.inputChanged.fire(newInput);
    }

    // Private instance methods
    private calculateEffectiveGutterRadius(): number {
        return this.gutterRadiusInPixels - this.thumbRadiusInPixels;
    }

    private calculateInput(inputPoint: Vector2): Vector2 {
        const effectiveGutterRadius = this.calculateEffectiveGutterRadius();
        const inputDisplacementFromGutterCenter = inputPoint.sub(this.gutterCenterPoint);

        let newInput = new Vector2();
        if (inputDisplacementFromGutterCenter.Magnitude > 0) {
            newInput = inputDisplacementFromGutterCenter.Unit.mul(math.clamp(inputDisplacementFromGutterCenter.Magnitude / effectiveGutterRadius, -1, 1));
        }

        return newInput;
    }

    private getViewportSize(): Vector2 {
        if (Workspace.CurrentCamera === undefined) {
            throw `Cannot get viewport size because CurrentCamera is undefined`;
        }
        const [ guiInsetTopLeft, guiInsetBottomRight ] = GuiService.GetGuiInset();
        const viewportTopLeft = guiInsetTopLeft;
        const viewportBottomRight = Workspace.CurrentCamera.ViewportSize.sub(guiInsetBottomRight);
        const viewportSize = viewportBottomRight.sub(viewportTopLeft);

        return viewportSize;
    }
}