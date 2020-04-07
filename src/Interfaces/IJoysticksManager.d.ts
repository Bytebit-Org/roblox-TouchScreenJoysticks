import { IJoystick } from "./IJoystick";
import { IJoystickConfiguration } from "./IJoystickConfiguration";
import { IDestroyable } from "@rbxts/dumpster";

/** Manages and orchestrates user input for a list of Joysticks */
export interface IJoysticksManager extends IDestroyable {
	/**
	 * Creates a new `IJoystick` based on the given `IJoystickConfiguration`
	 * @param configuration The configuration for the new Joystick
	 * @returns The new `IJoystick` instance
	 */
	createJoystick(configuration: IJoystickConfiguration): IJoystick;
}
