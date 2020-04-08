/** An internal class responsible for calculating joystick input given an actual touch input point */
export interface IJoystickInputCalculator {
	/**
	 * Calculates the input given an actual touch input point
	 * @param gutterCenterPoint The center point of the gutter, in the same space as the input point
	 * @param gutterRadiusInPixels The radius of the gutter in pixels, where pixels should reflect one full unit in the space of the input point
	 * @param relativeThumbRadius The relative thumb radius of the thumb in the gutter
	 * @param inputPoint The input point
	 * @returns The calculated input
	 */
	calculate(
		gutterCenterPoint: Vector2,
		gutterRadiusInPixels: number,
		relativeThumbRadius: number,
		inputPoint: Vector2,
	): Vector2;
}
