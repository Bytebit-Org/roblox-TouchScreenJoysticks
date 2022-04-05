import { IGuiWindowRegion } from "./IGuiWindowRegion";
import { IJoystickRenderer } from "./IJoystickRenderer";

/** The interface for constructing a new `IJoystick` */
export interface IJoystickConfiguration {
	/** Defines the screen region in which the `IJoystick` instance can be activated by the player's input */
	activationRegion: IGuiWindowRegion;

	/** Defines the gutter radius in pixels */
	gutterRadiusInPixels: number;

	/** Defines the inactive center point in the viewport of the `IJoystick` instance */
	inactiveCenterPoint: Vector2;

	/**
	 * Defines whether the `IJoystick` instance should initialize as enabled.
	 * Defaults to false.
	 */
	initializedEnabled?: boolean;

	/**
	 * Defines whether the `IJoystick` instance should initialize as visible.
	 * Defaults to false.
	 */
	initializedVisible?: boolean;

	/**
	 * Defines the priority leve lof the `IJoystick` instance.
	 * Higher priorities take precedence when initial touches could activate more than one joystick.
	 * Equal priorities are decided at random.
	 * Defaults to 1.
	 */
	priorityLevel?: number;

	/** Defines the renderer instance for the `IJoystick` instance */
	renderer: IJoystickRenderer;

	/** Defines the thumb radius as a number in the range [0, 1] relative to the gutter radius */
	relativeThumbRadius: number;

	/**
	 * Defines whether the joystick should recenter to the initial input point when activated.
	 * Defaults to true.
	 */
	shouldMoveCenterPointWhenActivated?: boolean;
}
