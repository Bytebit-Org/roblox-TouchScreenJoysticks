import { IDestroyable } from "@rbxts/dumpster";

/** Defines a component for the CompositeJoystickRenderer */
export interface ICompositeJoystickRendererComponent extends IDestroyable {
	/**
	 * Gets the instance of the component that can be used as the Parent for sub-components
	 * @returns Returns the instance
	 */
	getParentableInstance(): Instance;

	/** Hides any rendered instances */
	hide(): void;

	/**
	 * Renders the component with the given properties
	 * @param position The position to set for the center on the rendered GUI instance
	 * @param size The size to set on the rendered GUI instance
	 * @param zIndex The Z-index to set on the rendered GUI instance
	 * @param parent The parent for the rendered GUI instance
	 */
	render(position: UDim2, size: UDim2, zIndex: number, parent: Instance): void;
}
