import { IViewportRegion } from "./IViewportRegion";
import { IRenderer } from "./IRenderer";

/** The interface for constructing a new `Joystick` */
export interface IJoystickConfiguration {
    /** Defines the screen region in which the `Joystick` instance can be activated by the player's input */
    activationRegion: IViewportRegion;

    /** Defines the screen region in which the `Joystick` instance can be rendered. Defaults to the entire viewport. */
    renderableRegion?: IViewportRegion;

    /** Defines the renderer instance for the gutter of the `Joystick` instance */
    gutterRenderer: IRenderer;

    /** Defines the renderer instance for the thumb of the `Joystick` instance */
    thumbRenderer: IRenderer;

    /** Defines the inactive center point in the viewport of the `Joystick` instance */
    inactiveCenterPoint: Vector2;

    /** Defines the priority leve lof the `Joystick` instance. Defaults to 1. */
    priorityLevel?: number;

    /** Defines whether the `Joystick` instance should initialize as enabled. Defaults to false. */
    initializedEnabled?: boolean;

    /** Defines whether the `Joystick` instance should initialize as visible. Defaults to false. */
    initializedVisible?: boolean;
}