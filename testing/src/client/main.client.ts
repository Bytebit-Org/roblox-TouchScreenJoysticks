import { Joystick, RectangleViewportRegion, FilledCircleRenderer } from "@rbxts/touch-screen-joysticks";
import { Workspace, UserInputService, GuiService } from "@rbxts/services";

do { wait() } while (!Workspace.CurrentCamera)

wait(5);
UserInputService.ModalEnabled = true;

const [ guiInsetTopLeft, guiInsetBottomRight ] = GuiService.GetGuiInset();
const realTopLeft = guiInsetTopLeft;
const realBottomRight = Workspace.CurrentCamera.ViewportSize.sub(guiInsetBottomRight);
const viewportSize = realBottomRight.sub(realTopLeft);

const leftJoystick = Joystick.create({
    activationRegion: new RectangleViewportRegion(new Vector2(0, 0), new Vector2(viewportSize.X / 2, viewportSize.Y)),
    gutterRadiusInPixels: 50,
    gutterRenderer: new FilledCircleRenderer(Color3.fromRGB(0, 170, 255), 0.8),
    inactiveCenterPoint: new Vector2(80, viewportSize.Y - 80),
    thumbRadiusInPixels: 30,
    thumbRenderer: new FilledCircleRenderer(Color3.fromRGB(0, 170, 255), 0),
    initializedEnabled: true,
    initializedVisible: true,
    priorityLevel: 1,
});

const rightJoystick = Joystick.create({
    activationRegion: new RectangleViewportRegion(new Vector2(viewportSize.X / 2, 0), new Vector2(viewportSize.X, viewportSize.Y)),
    gutterRadiusInPixels: 50,
    gutterRenderer: new FilledCircleRenderer(Color3.fromRGB(255, 85, 0), 0.8),
    inactiveCenterPoint: new Vector2(viewportSize.X - 80, viewportSize.Y - 80),
    thumbRadiusInPixels: 30,
    thumbRenderer: new FilledCircleRenderer(Color3.fromRGB(255, 85, 0), 0),
    initializedEnabled: true,
    initializedVisible: true,
    priorityLevel: 1,
});

UserInputService.TouchStarted.Connect(inputObject => {
    print("touchpos", inputObject.Position);
});
