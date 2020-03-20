# requirements
- create multiple joysticks
- assign priority to overlapping joysticks
  - always render active joysticks above inactive joysticks
- enable and disable joysticks while still rendering
- add and remove joysticks from rendering at will
- change colors and images at will
  - also allow custom rendering for things like recharge animations
- allow joysticks to recenter when active
  - this should automatically move to be centered with the initial touch except that this should *not* ever go outside the renderable region (e.g. if the user touches the very left side of the screen, this should be considered left movement and the recentering should go as far left as it can such that the edge of the region is tangential with the radius of the input)
- allow multiple joysticks to be active at the same time
- allow radii to be customizable and changeable at will
- expose an abundance of signals for consumers

# basic design plan
using a singleton joystickmanager, listen for user input events and keep track of active touches\
have each individual joystick communicate with the singleton joystickmanager (opaque from consumer)\
each joystick should have:
- activation region
- renderable region (which can default to the entire GUI window)
- gutter renderer
  - should provide a default `filledCircleGutterRenderer` class
- thumb renderer
  - should provide a default `filledCircleThumbRenderer` class
- inactiveCenterPoint
- priority level
- enabled state
- visible state
- signals
  - enabled
  - disabled
  - visibilityChanged
  - activated
  - deactivated
  - inputChanged