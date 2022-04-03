import { ICompositeJoystickRendererComponent } from "../../../../Interfaces/ICompositeJoystickRendererComponent";

/** An implementation of `IJoystickRenderer` that renders a solid color, filled circle */
export class SolidFilledCircle implements ICompositeJoystickRendererComponent {
	private readonly frame: Frame;

	private isDestroyed = false;

	/**
	 * Creates a new instance
	 * @param color A `Color3` that describes the color of the filled circle
	 * @param transparency An optional `number` in the range [0, 1] that describes the transparency of the filled circle. Defaults to 0.
	 */
	public constructor(color: Color3, transparency?: number) {
		const frame = new Instance("Frame");
		frame.AnchorPoint = new Vector2(0.5, 0.5);
		frame.BackgroundTransparency = transparency !== undefined ? transparency : 0;
		frame.BackgroundColor3 = color;
		frame.BorderSizePixel = 0;

		const uiCorner = new Instance("UICorner");
		uiCorner.CornerRadius = new UDim(0.5, 0);
		uiCorner.Parent = frame;

		this.frame = frame;
	}

	public destroy() {
		this.frame.Destroy();
		this.isDestroyed = true;
	}

	public getParentableInstance() {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		return this.frame;
	}

	public hide() {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.frame.Parent = undefined;
	}

	public render(position: UDim2, size: UDim2, zIndex: number, parent: Instance) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.frame.Parent = undefined;

		this.frame.Position = position;
		this.frame.Size = size;
		this.frame.ZIndex = zIndex;

		this.frame.Parent = parent;
	}
}
