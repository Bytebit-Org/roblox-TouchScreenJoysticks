import { IDestroyable } from "@rbxts/dumpster";

/** An interface for renderers for both the gutter and thumb */
export interface IRenderer extends IDestroyable {
    /** Hides any rendered instances */
    hide(): void;
    
    /**
     * Renders on the screen
     * @param absoluteCenter A `Vector2` describing the absolute center of the renderer in the viewport 
     * @param radiusInPixels A `number` describing the radius in pixels to render from the given center
     */
    render(absoluteCenter: Vector2, radiusInPixels: number): void;
}