import { IRenderer } from "../../Interfaces/IRenderer";

const IMAGE_ASSET = "rbxassetid://4798571099";

/** An implementation of `IRenderer` that renders a solid color, filled circle */
export class FilledCircleRenderer implements IRenderer {
    private readonly imageLabel: ImageLabel;
    
    private isDestroyed = false;

    /**
     * Creates a new instance
     * @param color A `Color3` that describes the color of the filled circle
     * @param transparency An optional `number` in the range [0, 1] taht describes the transparency of the filled circle. Defaults to 0.
     */
    public constructor(color: Color3, transparency?: number) {
        const imageLabel = new Instance("ImageLabel");
        imageLabel.AnchorPoint = new Vector2(0.5, 0.5);
        imageLabel.BackgroundTransparency = 1;
        imageLabel.Image = IMAGE_ASSET;
        imageLabel.ImageColor3 = color;
        imageLabel.ImageTransparency = transparency !== undefined ? transparency : 0;

        this.imageLabel = imageLabel;
    }

    public destroy() {
        this.imageLabel.Destroy();
        this.isDestroyed = true;
    }

    public hide() {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }

        this.imageLabel.Parent = undefined;
    }

    public render(absoluteCenter: Vector2, radiusInPixels: number, zIndex: number, parent: Instance) {
        if (this.isDestroyed) {
            throw `Instance is destroyed`;
        }
         
        this.imageLabel.Parent = undefined;

        this.imageLabel.Position = new UDim2(0, absoluteCenter.X, 0, absoluteCenter.Y);
        this.imageLabel.Size = new UDim2(0, 2 * radiusInPixels, 0, 2 * radiusInPixels);
        this.imageLabel.ZIndex = zIndex;

        this.imageLabel.Parent = parent;
    }
}