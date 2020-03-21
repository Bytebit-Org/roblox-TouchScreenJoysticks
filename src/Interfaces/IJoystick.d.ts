import { IDestroyable } from "@rbxts/dumpster";
import { IReadOnlySignal } from "@rbxts/signals-tooling";
import { IGuiWindowRegion } from "./IGuiWindowRegion";
import { IJoystickRenderer } from "./IJoystickRenderer";

/** Defines a joystick */
export interface IJoystick extends IDestroyable {
    // Instance members
    /**
     * A readonly, optional field that reports the current input for the instance, if any.
     * When defined, this field will be a `Vector2` where each component will be in the range [0, 1] and the magnitude will never exceed 1 describing the position in the unit circle defined by the gutter of the instance.
     * This field will be `undefined` when `isActive` is false and will always be defined when `isActive` is true.
     */
    readonly input?: Vector2;

    /**
     * A readonly field for determining whether the instance is active.
     * When active, the joystick is actively being interacted with by the player.
     */
    readonly isActive: boolean;

    /**
     * A readonly field for determining whether the instance is enabled.
     * When enabled and visible, the joystick can be interacted with by the player.
     */
    readonly isEnabled: boolean;

    /**
     * A readonly field for determining whether the instance is visible.
     * When visible, the joystick will be rendered.
     */
    readonly isVisible: boolean;

    /** A readonly field for determining the priority level for the instance */
    readonly priorityLevel: number;

    // Instance signals
    /**
     * Fired when the instance is activated
     * @argument initialInput A `Vector2` describing the initial input from the player upon activation
     */
    readonly activated: IReadOnlySignal<(initialInput: Vector2) => void>;

    /**
     * Fired when the instance is deactivated
     * @argument finalInput A `Vector2` describing the final input from the player just prior to deactivation
     */
    readonly deactivated: IReadOnlySignal<(finalInput: Vector2) => void>;

    /** Fired when the instance is disabled */
    readonly disabled: IReadOnlySignal;

    /** Fired when the instance is enabled */
    readonly enabled: IReadOnlySignal;

    /**
     * Fired when the instance's input has changed
     * @argument newInput A `Vector2` describing the new input from the player
     */
    readonly inputChanged: IReadOnlySignal<(newInput: Vector2) => void>;

    /**
     * Fired when the instance's visibility has changed
     * @argument newValue A `boolean` indicating whether the instance is now visible
     */
    readonly visibilityChanged: IReadOnlySignal<(newValue: boolean) => void>;
    
    // Instance methods
    /**
     * Destroys the instance, its renderers, any other associated instances, and disconnects all connections to its signals.
     * An instance cannot be re-used after being destroyed.
     */
    destroy(): void;

    /**
     * Sets the activation region of the instance
     * @param newRegion An `IGuiWindowRegion` to use as the new activation region for the instance
     */
    setActivationRegion(newRegion: IGuiWindowRegion): void;

    /**
     * Sets the enabled state of the instance to the given new value.
     * If the new value does not match the current state, then the appropriate signal (either `enabled` or `disabled`) will fire.
     * @param newValue A `boolean` indicating whether the instance should be enabled
     */
    setEnabled(newValue: boolean): void;

    /**
     * Sets the gutter radius in pixels for the instance
     * @param newRadiusInPixels A `number` to use as the new radius in pixels for the gutter of the instance
     */
    setGutterRadiusInPixels(newRadiusInPixels: number): void;

    /**
     * Sets the inactive center point for the instance
     * @param newPoint A `Vector2` to use as the new inactive center point for the instance
     */
    setInactiveCenterPoint(newPoint: Vector2): void;

    /**
     * Sets the priority level for the instance
     * @param newPriorityLevel A `number` to use as the new priority level for the instance
     */
    setPriorityLevel(newPriorityLevel: number): void;

    /**
     * Sets the renderer for the instance and destroys the previous renderer
     * @param newRenderer An `IJoystickRenderer` to use as the new renderer for the instance
     */
    setRenderer(newRenderer: IJoystickRenderer): void;

    /**
     * Sets the relative thumb radius for the instance
     * @param newRelativeThumbRadius A `number` in the range [0, 1] to use as the new relative thumb radius of the instance
     */
    setRelativeThumbRadius(newRelativeThumbRadius: number): void;

    /**
     * Sets the visible state of the instance to the given new value.
     * If the new value does not match the current state, then the `visibilityChanged` signal will fire.
     * @param newValue A `boolean` indicating whether the instance should be visible
     */
    setVisible(newValue: boolean): void;
}