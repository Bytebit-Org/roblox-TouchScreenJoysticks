import { ICompositeJoystickRendererComponent } from "../../../../Interfaces/ICompositeJoystickRendererComponent";

/** An implementation of `IJoystickRenderer` that renders a given image */
export class Image implements ICompositeJoystickRendererComponent {
	private readonly imageLabel: ImageLabel;

	private isDestroyed = false;

	/**
	 * Creates a new instance
	 * @param image A `string` that describes the image asset
	 * @param imageColor An optional `Color3` that describes the image color of the GUI component. Defaults to white.
	 * @param imageTransparency An optional `number` in the range [0, 1] that describes the transparency of the GUI component. Defaults to 0.
	 */
	public constructor(image: string, imageColor?: Color3, transparency?: number) {
		const imageLabel = new Instance("ImageLabel");
		imageLabel.AnchorPoint = new Vector2(0.5, 0.5);
		imageLabel.BackgroundTransparency = 1;
		imageLabel.Image = image;
		imageLabel.ImageColor3 = imageColor !== undefined ? imageColor : new Color3(1, 1, 1);
		imageLabel.ImageTransparency = transparency !== undefined ? transparency : 0;

		this.imageLabel = imageLabel;
	}

	public destroy() {
		this.imageLabel.Destroy();
		this.isDestroyed = true;
	}

	public getParentableInstance() {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		return this.imageLabel;
	}

	public hide() {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.imageLabel.Parent = undefined;
	}

	public render(position: UDim2, size: UDim2, zIndex: number, parent: Instance) {
		if (this.isDestroyed) {
			throw `Instance is destroyed`;
		}

		this.imageLabel.Parent = undefined;

		this.imageLabel.Position = position;
		this.imageLabel.Size = size;
		this.imageLabel.ZIndex = zIndex;

		this.imageLabel.Parent = parent;
	}
}
