import { IViewportRegion } from "./IViewportRegion";
import { IRenderer } from "./IRenderer";

/** The interface for constructing a new `IJoystick` */
export interface IJoystickConfiguration {
    /** Defines the screen region in which the `IJoystick` instance can be activated by the player's input */
    activationRegion: IViewportRegion;

    /** Defines the gutter radius in pixels */
    gutterRadiusInPixels: number;

    /** Defines the renderer instance for the gutter of the `IJoystick` instance */
    gutterRenderer: IRenderer;

    /** Defines the thumb radius in pixels */
    thumbRadiusInPixels: number;

    /** Defines the renderer instance for the thumb of the `IJoystick` instance */
    thumbRenderer: IRenderer;

    /** Defines the inactive center point in the viewport of the `IJoystick` instance */
    inactiveCenterPoint: Vector2;

    /**
     * Defines the priority leve lof the `IJoystick` instance.
     * Defaults to 1.
     */
    priorityLevel?: number;

    /**
     * Defines whether the `IJoystick` instance should initialize as enabled.
     * Defaults to false.
     */
    initializedEnabled?: boolean;

    /**
     * Defines whether the `IJoystick` instance should initialize as visible.
     * Defaults to false.
     */
    initializedVisible?: boolean;
}