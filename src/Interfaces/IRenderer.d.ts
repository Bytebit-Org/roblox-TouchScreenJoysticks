import { IDestroyable } from "@rbxts/dumpster";

/** An interface for renderers for both the gutter and thumb */
export interface IRenderer extends IDestroyable {
    /** Hides any rendered instances */
    hide(): void;
    
    /**
     * Renders on the screen
     * @param absoluteCenter A `Vector2` describing the absolute center of the renderer in the viewport 
     * @param radiusInPixels A `number` describing the radius in pixels to render from the given center
     * @param zIndex A `number` describing the z-index of the element and will typically match the priority level of the parent `Joystick` instance
     */
    render(absoluteCenter: Vector2, radiusInPixels: number, zIndex: number): void;
}