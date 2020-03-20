# Overview
This project is an open-source tool for composing multiple, customized touch screen joysticks with the objective of improving the tooling available to Roblox developers for mobile games.

# Links
- [API Documentation](package/DOCUMENTATION.md)

# Example
![Screenshot_20200320-164323_Roblox](https://user-images.githubusercontent.com/17803348/77207577-208bdc00-6ad0-11ea-9864-175fe452ccc9.jpg)

It only takes one line of code to create a joystick! Below is an example of just a handful of lines of code that can be used to quickly generate two joysticks, one on each side of the screen, and print their inputs:

```TS
import { CompositeJoystickRenderer, SolidFilledCircle, Joystick, RectangleGuiWindowRegion } from "@rbxts/touch-screen-joysticks";
import { Workspace, GuiService } from "@rbxts/services";

do { wait() } while (!Workspace.CurrentCamera)

wait(1); // To wait for screen to flip to appropriate orientation

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
```
