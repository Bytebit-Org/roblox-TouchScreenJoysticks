import { IJoystickRenderer } from "../../../Interfaces/IJoystickRenderer";
import { ICompositeJoystickRendererComponent } from "../../../Interfaces/ICompositeJoystickRendererComponent";

/** A packaged renderer that combines two components - one for the gutter, one for the thumb - to render a joystick. */
export class CompositeJoystickRenderer implements IJoystickRenderer {
	private readonly gutterComponent: ICompositeJoystickRendererComponent;
	private readonly thumbComponent: ICompositeJoystickRendererComponent;

	private isDestroyed = false;

	/**
	 * Creates a new instance
	 * @param gutterComponent The gutter rendering component
	 * @param thumbComponent The thumb rendering component
	 */
	public constructor(
		gutterComponent: ICompositeJoystickRendererComponent,
		thumbComponent: ICompositeJoystickRendererComponent,
	) {
		this.gutterComponent = gutterComponent;
		this.thumbComponent = thumbComponent;
	}

	public destroy() {
		this.isDestroyed = true;

		this.gutterComponent.destroy();
		this.thumbComponent.destroy();
	}

	public hide() {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.gutterComponent.hide();
		this.thumbComponent.hide();
	}

	public render(
		absoluteCenter: Vector2,
		relativeThumbPosition: Vector2,
		gutterRadiusInPixels: number,
		relativeThumbRadius: number,
		zIndex: number,
		parent: Instance,
	) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		const gutterPosition = new UDim2(0, absoluteCenter.X, 0, absoluteCenter.Y);
		const gutterSize = new UDim2(0, 2 * gutterRadiusInPixels, 0, 2 * gutterRadiusInPixels);

		const thumbPosition = new UDim2(0.5 + relativeThumbPosition.X / 2, 0, 0.5 + relativeThumbPosition.Y / 2, 0);
		const thumbSize = new UDim2(relativeThumbRadius, 0, relativeThumbRadius, 0);

		this.gutterComponent.render(gutterPosition, gutterSize, zIndex, parent);
		this.thumbComponent.render(thumbPosition, thumbSize, 1, this.gutterComponent.getParentableInstance());
	}
}
