import { IDestroyable } from "@rbxts/dumpster";

/** An interface for renderers for both the gutter and thumb */
export interface IJoystickRenderer extends IDestroyable {
    /** Hides any rendered instances */
    hide(): void;
    
    /**
     * Renders the joystick GUI elements to the given parent
     * @param absoluteCenter A `Vector2` describing the absolute center of the renderer in the GUI window 
     * @param relativeThumbPosition A `Vector2` describing the relative thumb position in the gutter. Will reflect a pair of coordinates within a unit circle.
     * @param gutterRadiusInPixels A `number` describing the radius in pixels to render from the given gutter center
     * @param relativeThumbRadius A `number` in the range [0, 1] describing the radius of the thumb relative to the radius of the gutter
     * @param zIndex A `number` describing the z-index of the element and will typically match the priority level of the parent `IJoystick` instance
     * @param parent An `Instance` to assign as the parent for all gui `Instance` object(s) created during rendering. Typically this will be the `ScreenGui` generated for the `IJoystick` instance.
     */
    render(absoluteCenter: Vector2, relativeThumbPosition: Vector2, gutterRadiusInPixels: number, relativeThumbRadius: number, zIndex: number, parent: Instance): void;
}