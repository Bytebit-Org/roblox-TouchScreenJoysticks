# API documentation
*This API documentation is a WIP and subject to change. For now, this is intended as the goal API.*

## Gui Window regions

### IGuiWindowRegion
An interface for defining GUI region regions so as to check if a given point exists in the region\
Intended to be implemented by developers who may need a more specific implementation

#### Instance methods
`isPointInRegion(point: Vector2): boolean`\
Determines whether the given point exists in the region
##### Parameters
- point\
The GUI window point in question\
Units should be in pixels
##### Returns
Returns a value indicating whether the given point is in the region

### RectangleGuiWindowRegion
An implementation of [`IGuiWindowRegion`](#IGuiWindowRegion) that describes a rectangular region of the GUI window

#### Constructor
`new RectangleGuiWindowRegion(topLeft: Vector2, bottomRight: Vector2)`
##### Parameters
- topLeft\
A `Vector2` describing the top-left point in the GUI window of the region
- bottomRight\
A `Vector2` describing the bottom-right point in the GUI window of the region

### CircleGuiWindowRegion
An implementation of [`IGuiWindowRegion`](#IGuiWindowRegion) that describes a circular region of the GUI window

#### Constructor
`new CircleGuiWindowRegion(centerPoint: Vector2, radiusInPixels: number)`
##### Parameters
- centerPoint\
A `Vector2` describing the center point in the GUI window of the region
- radiusInPixels\
A `number` describing the radius in pixels of the region

## Renderers

### IJoystickRenderer
An interface for rendering joysticks\
Intended to be implemented by developers who may need a more specific implementation

#### Instance methods
`destroy(): void`\
Destroys the instance, making it incapable of rendering later and cleaning up all of its related instances and signals

`hide(): void`\
Hides any rendered instances

`render(absoluteCenter: Vector2, relativeThumbPosition: Vector2, gutterRadiusInPixels: number, relativeThumbRadius: number, zIndex: number, parent: Instance): void`\
Renders the joystick GUI elements to the given parent
##### Parameters
- absoluteCenter\
A `Vector2` describing the absolute center of the renderer in the GUI window
- relativeThumbPosition\
A `Vector2` describing the relative thumb position in the gutter\
Will reflect a pair of coordinates within a unit circle
- gutterRadiusInPixels\
A `number` describing the radius in pixels to render from the given gutter center
- relativeThumbRadius\
A `number` in the range [0, 1] describing the radius of the thumb relative to the radius of the gutter
- zIndex\
A `number` describing the z-index of the element\
Typically this will match the priority level of the parent [`IJoystick`](#IJoystick) instance
- parent\
An `Instance` to assign as the parent for all gui `Instance` object(s) created during rendering\
Typically this will be the `ScreenGui` generated for the [`IJoystick`](#IJoystick) instance

### CompositeJoystickRenderer
A packaged renderer that combines two components - one for the gutter, one for the thumb - to render a joystick.

#### Constructor
`new CompositeJoystickRenderer(gutterComponent: ICompositeJoystickRendererComponent, thumbComponent: ICompositeJoystickRendererComponent)`\
Creates a new instance
##### Parameters
- gutterComponent\
The gutter rendering component
- thumbComponent\
The thumb rendering component

### ICompositeJoystickRendererComponent
Defines a component for the CompositeJoystickRenderer\
Intended to be implemented by developers who may need a more specific implementation

#### Instance methods
`getParentableInstance(): Instance`\
Gets the instance of the component that can be used as the Parent for sub-components
##### Returns
Returns the instance

`hide(): void`\
Hides any rendered instances

`render(anchorPoint: Vector2, position: UDim2, size: UDim2, zIndex: number, parent: Instance): void`\
Renders the component with the given properties
##### Parameters
- anchorPoint\
The anchor point to set on the rendered GUI instance
- position\
The position to set on the rendered GUI instance
- size\
The size to set on the rendered GUI instance
- zIndex\
The Z-index to set on the rendered GUI instance
- parent\
The parent for the rendered GUI instance

### Image
An implementation of [`ICompositeJoystickRendererComponent`](#ICompositeJoystickRendererComponent) that renders a provided image

#### Constructor
`new Image(image: string, imageColor?: Color3, imageTransparency?: number)`
##### Parameters
- image\
A `string` that describes the image asset
- color\
An optional `Color3` that describes the image color of the GUI component. Defaults to white.
- transparency\
An optional `number` in the range [0, 1] that describes the transparency of the GUI component\
Defaults to 0

### SolidFilledCircle
An implementation of [`ICompositeJoystickRendererComponent`](#ICompositeJoystickRendererComponent) that renders a solid color, filled circle

#### Constructor
`new FilledCircleRenderer(color: Color3, transparency?: number)`
##### Parameters
- color\
A `Color3` that describes the color of the filled circle
- transparency\
An optional `number` in the range [0, 1] that describes the transparency of the filled circle\
Defaults to 0

## Joystick API

### IJoystickConfiguration
The interface for constructing a new [`IJoystick`](#IJoystick)

#### Fields
- activationRegion: [`IGuiWindowRegion`](#IGuiWindowRegion)\
Defines the screen region in which the [`IJoystick`](#IJoystick) instance can be activated by the player's input
- gutterRadiusInPixels: `number`\
Defines the gutter radius in pixels
- inactiveCenterPoint: `Vector2`\
Defines the inactive center point in the GUI region of the [`IJoystick`](#IJoystick) instance
- initializedEnabled?: `boolean`\
Defines whether the [`IJoystick`](#IJoystick) instance should initialize as enabled\
Defaults to false
- initializedVisible?: `boolean`\
Defines whether the [`IJoystick`](#IJoystick) instance should initialize as visible\
Defaults to false
- priorityLevel?: `number`\
Defines the priority leve lof the [`IJoystick`](#IJoystick) instance\
Defaults to 1
- renderer: [`IJoystickRenderer`](#IJoystickRenderer)\
Defines the renderer instance for the [`IJoystick`](#IJoystick) instance
- relativeThumbRadius: `number`\
Defines the thumb radius as a number in the range [0, 1] relative to the gutter radius

### IJoystick
Defines a joystick

#### Instance members
`readonly input?: Vector2`\
A readonly, optional field that reports the current input for the instance, if any\
When defined, this field will be a `Vector2` where each component will be in the range [0, 1] and the magnitude will never exceed 1 describing the position in the unit circle defined by the gutter of the instance\
This field will be `undefined` when `isActive` is false and will always be defined when `isActive` is true

`readonly isActive: boolean`\
A readonly field for determining whether the instance is active\
When active, the joystick is actively being interacted with by the player

`readonly isEnabled: boolean`\
A readonly field for determining whether the instance is enabled\
When enabled and visible, the joystick can be interacted with by the player

`readonly isVisible: boolean`\
A readonly field for determining whether the instance is visible\
When visible, the joystick will be rendered

`readonly priorityLevel: number`\
A readonly field for determining the priority level for the instance

#### Instance signals
`readonly activated: IReadOnlySignal<(initialInput: Vector2) => void>`\
Fired when the instance is activated
##### Arguments
- initialInput\
A `Vector2` describing the initial input from the player upon activation

`readonly deactivated: IReadOnlySignal<(finalInput: Vector2) => void>`\
Fired when the instance is deactivated
##### Arguments
- finalInput\
A `Vector2` describing the final input from the player just prior to deactivation

`readonly disabled: IReadOnlySignal`\
Fired when the instance is disabled

`readonly enabled: IReadOnlySignal`\
Fired when the instance is enabled

`readonly inputChanged: IReadOnlySignal<(newInput: Vector2) => void>`\
Fired when the instance's input has changed
##### Arguments
- newInput\
A `Vector2` describing the new input from the player

`readonly visibilityChanged: IReadOnlySignal<(newValue: boolean) => void>`\
Fired when the instance's visibility has changed
##### Arguments
- newValue\
A `boolean` indicating whether the instance is now visible

#### Instance methods
`destroy(): void`\
Destroys the instance, its renderers, any other associated instances, and disconnects all connections to its signals\
An instance cannot be re-used after being destroyed

`setActivationRegion(newRegion: IGuiWindowRegion): void`\
Sets the activation region of the instance
##### Parameters
- newRegion\
An [`IGuiWindowRegion`](#IGuiWindowRegion) to use as the new activation region for the instance

`setEnabled(newValue: boolean): void`\
Sets the enabled state of the instance to the given new value\
If the new value does not match the current state, then the appropriate signal (either `enabled` or `disabled`) will fire
##### Parameters
- newValue\
A `boolean` indicating whether the instance should be enabled

`setGutterRadiusInPixels(newRadiusInPixels: number): void`\
Sets the gutter radius in pixels for the instance
##### Parameters
- newRadiusInPixels\
A `number` to use as the new radius in pixels for the gutter of the instance

`setInactiveCenterPoint(newPoint: Vector2): void`\
Sets the inactive center point for the instance
##### Parameters
- newPoint\
A `Vector2` to use as the new inactive center point for the instance

`setPriorityLevel(newPriorityLevel: number): void`\
Sets the priority level for the instance
##### Parameters
- newPriorityLevel\
A `number` to use as the new priority level for the instance

`setRenderer(newRenderer: IJoystickRenderer): void`\
Sets the renderer for the instance and destroys the previous renderer
##### Parameters
- newRenderer\
An [`IJoystickRenderer`](#IJoystickRenderer) to use as the new renderer for the instance

`setRelativeThumbRadius(newRelativeThumbRadius: number): void`\
Sets the relative thumb radius for the instance
##### Parameters
- newRelativeThumbRadius\
A `number` in the range [0, 1] to use as the new relative thumb radius of the instance

`setVisible(newValue: boolean): void`\
Sets the visible state of the instance to the given new value\
If the new value does not match the current state, then the `visibilityChanged` signal will fire
##### Parameters
- newValue\
A `boolean` indicating whether the instance should be visible

### Joystick
The actual implementation of [`IJoystick`](#IJoystick)

#### Static methods
`Joystick.create(configuration: IJoystickConfiguration): IJoystick`\
Creates a new instance
##### Parameters
- configuration\
An [`IJoystickConfiguration`](#IJoystickConfiguration) that defines the configuration parameters for the new [`IJoystick`](#IJoystick) instance
##### Returns
Returns the new instance