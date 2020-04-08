export class JoystickInputCalculator {
	public calculate(
		gutterCenterPoint: Vector2,
		gutterRadiusInPixels: number,
		relativeThumbRadius: number,
		inputPoint: Vector2,
	): Vector2 {
		const effectiveGutterRadius = this.calculateEffectiveGutterRadius(gutterRadiusInPixels, relativeThumbRadius);
		const inputDisplacementFromGutterCenter = inputPoint.sub(gutterCenterPoint);

		let newInput = new Vector2();
		if (inputDisplacementFromGutterCenter.Magnitude > 0) {
			newInput = inputDisplacementFromGutterCenter.Unit.mul(
				math.clamp(inputDisplacementFromGutterCenter.Magnitude / effectiveGutterRadius, -1, 1),
			);
		}

		return newInput;
	}

	private calculateEffectiveGutterRadius(gutterRadiusInPixels: number, relativeThumbRadius: number): number {
		return gutterRadiusInPixels * (1 - relativeThumbRadius);
	}
}
