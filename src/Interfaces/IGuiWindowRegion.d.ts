/** An interface for defining viewport regions so as to check if a given point exists in the region */
export interface IGuiWindowRegion {
    /**
     * Determines whether the given point exists in the region
     * @param point The viewport point in question. Units should be in pixels.
     * @returns Returns a value indicating whether the given point is in the region
     */
    isPointInRegion(point: Vector2): boolean;
}