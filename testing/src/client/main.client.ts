import { CompositeJoystickRenderer, SolidFilledCircle, Joystick, RectangleGuiWindowRegion } from "@rbxts/touch-screen-joysticks";
import { Workspace, GuiService } from "@rbxts/services";

do { wait() } while (!Workspace.CurrentCamera)

wait();

(Workspace.CurrentCamera.Changed as unknown as RBXScriptSignal).Connect(() => {
    Workspace.CurrentCamera!.CameraType = Enum.CameraType.Scriptable;
});

const [ guiInsetTopLeft, guiInsetBottomRight ] = GuiService.GetGuiInset();
const realTopLeft = guiInsetTopLeft;
const realBottomRight = Workspace.CurrentCamera.ViewportSize.sub(guiInsetBottomRight);
const guiWindow = realBottomRight.sub(realTopLeft);

const leftJoystick = Joystick.create({
    activationRegion: new RectangleGuiWindowRegion(new Vector2(0, 0), new Vector2(guiWindow.X / 2, guiWindow.Y)),
    gutterRadiusInPixels: 50,
    inactiveCenterPoint: new Vector2(80, guiWindow.Y - 80),
    initializedEnabled: true,
    initializedVisible: true,
    priorityLevel: 1,
    relativeThumbRadius: 0.6,
    renderer: new CompositeJoystickRenderer(new SolidFilledCircle(Color3.fromRGB(0, 170, 255), 0.8), new SolidFilledCircle(Color3.fromRGB(0, 170, 255), 0)),
});

leftJoystick.inputChanged.Connect(newInput => {
    print("left input", newInput);
});

const rightJoystick = Joystick.create({
    activationRegion: new RectangleGuiWindowRegion(new Vector2(guiWindow.X / 2, 0), new Vector2(guiWindow.X, guiWindow.Y)),
    gutterRadiusInPixels: 50,
    inactiveCenterPoint: new Vector2(guiWindow.X - 80, guiWindow.Y - 80),
    initializedEnabled: true,
    initializedVisible: true,
    priorityLevel: 1,
    relativeThumbRadius: 0.6,
    renderer: new CompositeJoystickRenderer(new SolidFilledCircle(Color3.fromRGB(255, 85, 0), 0.8), new SolidFilledCircle(Color3.fromRGB(255, 85, 0), 0)),
});

rightJoystick.inputChanged.Connect(newInput => {
    print("right input", newInput);
});
