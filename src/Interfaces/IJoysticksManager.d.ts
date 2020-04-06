import { IJoystick } from "./IJoystick";
import { IJoystickConfiguration } from "./IJoystickConfiguration";

/** Manages and orchestrates user input for a list of Joysticks */
export interface IJoysticksManager {
	/**
	 * Creates a new `IJoystick` based on the given `IJoystickConfiguration`
	 * @param configuration The configuration for the new Joystick
	 * @returns The new `IJoystick` instance
	 */
	createJoystick(configuration: IJoystickConfiguration): IJoystick;

	/**
	 * Destroys the given `IJoystick` instance
	 * @param joystick The `IJoystick` instance to destroy
	 * @throws Throws when the given `IJoystick` instance is not a member of this `IJoysticksManager`
	 */
	destroyJoystick(joystick: IJoystick): void;
}
