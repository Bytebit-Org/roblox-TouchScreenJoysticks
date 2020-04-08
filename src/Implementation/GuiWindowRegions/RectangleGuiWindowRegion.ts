import { IGuiWindowRegion } from "../../Interfaces/IGuiWindowRegion";

/** An implementation of `IGuiWindowRegion` that describes a rectangular region of the viewport */
export class RectangleGuiWindowRegion implements IGuiWindowRegion {
	private readonly topLeft: Vector2;
	private readonly bottomRight: Vector2;

	/**
	 * Creates a new instance
	 * @param topLeft A `Vector2` describing the top-left point in the viewport of the region
	 * @param bottomRight A `Vector2` describing the bottom-right point in the viewport of the region
	 */
	public constructor(topLeft: Vector2, bottomRight: Vector2) {
		this.topLeft = topLeft;
		this.bottomRight = bottomRight;
	}

	public isPointInRegion(point: Vector2) {
		const isInXBounds = this.topLeft.X <= point.X && point.X <= this.bottomRight.X;
		const isInYBounds = this.topLeft.Y <= point.Y && point.Y <= this.bottomRight.Y;

		return isInXBounds && isInYBounds;
	}
}
