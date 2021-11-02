# Touch Screen Joysticks
<p align="center">
	<a href="https://github.com/Bytebit-Org/roblox-TouchScreenJoysticks/actions">
        <img src="https://github.com/Bytebit-Org/roblox-TouchScreenJoysticks/workflows/CI/badge.svg" alt="CI status" />
    </a>
	<a href="http://makeapullrequest.com">
		<img src="https://img.shields.io/badge/PRs-welcome-blue.svg" alt="PRs Welcome" />
	</a>
	<a href="https://opensource.org/licenses/MIT">
		<img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT" />
	</a>
	<a href="https://discord.gg/QEz3v8y">
		<img src="https://img.shields.io/badge/discord-join-7289DA.svg?logo=discord&longCache=true&style=flat" alt="Discord server" />
	</a>
</p>

This project is an open-source tool for composing multiple, customized touch screen joysticks with the objective of improving the tooling available to Roblox developers for mobile games.

## Installation
### roblox-ts
Simply install to your [roblox-ts](https://roblox-ts.com/) project as follows:
```
npm i @rbxts/touch-screen-joysticks
```

### Wally
[Wally](https://github.com/UpliftGames/wally/) users can install this package by adding the following line to their `Wally.toml` under `[dependencies]`:
```
TouchScreenJoysticks = "bytebit/touch-screen-joysticks@1.0.5"
```

Then just run `wally install`.

### From model file
Model files are uploaded to every release as `.rbxmx` files. You can download the file from the [Releases page](https://github.com/Bytebit-Org/roblox-TouchScreenJoysticks/releases) and load it into your project however you see fit.

### From model asset
New versions of the asset are uploaded with every release. The asset can be added to your Roblox Inventory and then inserted into your Place via Toolbox by getting it [here.](https://www.roblox.com/library/7872552904/Serve-Package)

# Links
- [API Documentation](DOCUMENTATION.md)

# Example
![tscreenshot_20200320-164323_roblox](https://user-images.githubusercontent.com/17803348/77207941-0dc5d700-6ad1-11ea-886b-adaef10fa48c.jpg)\
<sup>*[Click here to watch a video demonstration.](https://streamable.com/s8vph)*</sup>

It only takes one line of code to create a joystick! Below is an example of just a handful of lines of code that can be used to quickly generate two joysticks, one on each side of the screen, and print their inputs:

```TS
import { CompositeJoystickRenderer, JoysticksManager, RectangleGuiWindowRegion, SolidFilledCircle } from "@rbxts/touch-screen-joysticks";
import { Workspace, GuiService } from "@rbxts/services";

do { wait() } while (!Workspace.CurrentCamera)

wait(1); // To wait for screen to flip to appropriate orientation

const [ guiInsetTopLeft, guiInsetBottomRight ] = GuiService.GetGuiInset();
const realTopLeft = guiInsetTopLeft;
const realBottomRight = Workspace.CurrentCamera.ViewportSize.sub(guiInsetBottomRight);
const guiWindow = realBottomRight.sub(realTopLeft);

const joysticksManager = JoysticksManager.create()

const leftJoystick = joysticksManager.createJoystick({
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

const rightJoystick = joysticksManager.createJoystick({
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
