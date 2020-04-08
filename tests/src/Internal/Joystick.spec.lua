return function()
	FOCUS()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local fitumi = require(ReplicatedStorage:WaitForChild("fitumi"))
    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local Joystick = TS.import(script, ReplicatedStorage, "TS", "Internal", "Joystick").Joystick;

	local a = fitumi.a

	describe("Joystick", function()
		it("should be constructable and fulfill its interface", function()
			local joystick;

			expect(function()
				joystick = Joystick.new(
					{
						activationRegion = a.fake(),
						gutterRadiusInPixels = 10,
						inactiveCenterPoint = Vector2.new(0, 0),
						initializedEnabled = true,
						initializedVisible = true,
						relativeThumbRadius = 0.5,
						renderer = a.fake()
					},
					--[[ currentCameraGetter ]] a.fake,
					--[[ guiService ]] a.fake(),
					--[[ joystickInputCalculator ]] a.fake(),
					--[[ joysticksManager ]] a.fake()
				)
			end).never.to.throw()

			-- public instance members
			expect(joystick.input).never.to.be.ok()
			expect(joystick.isActive).to.be.a("boolean")
			expect(joystick.isEnabled).to.be.a("boolean")
			expect(joystick.isVisible).to.be.a("boolean")
			expect(joystick.priorityLevel).to.be.a("number")

			-- public instance signals
			expect(joystick.activated).to.be.a("table")
			expect(joystick.deactivated).to.be.a("table")
			expect(joystick.disabled).to.be.a("table")
			expect(joystick.enabled).to.be.a("table")
			expect(joystick.inputChanged).to.be.a("table")
			expect(joystick.visibilityChanged).to.be.a("table")

			-- internal instance members
			expect(joystick.activationRegion).to.be.a("table")

			-- public methods
			expect(joystick.destroy).to.be.a("function")
			expect(joystick.setActivationRegion).to.be.a("function")
			expect(joystick.setEnabled).to.be.a("function")
			expect(joystick.setGutterRadiusInPixels).to.be.a("function")
			expect(joystick.setInactiveCenterPoint).to.be.a("function")
			expect(joystick.setPriorityLevel).to.be.a("function")
			expect(joystick.setRelativeThumbRadius).to.be.a("function")
			expect(joystick.setRenderer).to.be.a("function")
			expect(joystick.setVisible).to.be.a("function")

			-- internal methods
			expect(joystick.activate).to.be.a("function")
			expect(joystick.deactivate).to.be.a("function")
			expect(joystick.render).to.be.a("function")
			expect(joystick.updateInput).to.be.a("function")
		end)

		it("should initialize according to its given config", function()
			local configuration = {
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				priorityLevel = 1,
				relativeThumbRadius = 0.5,
				renderer = a.fake()
			}
			local joysticksManager = a.fake()
			local currentCameraGetter = a.fake
			local guiService = a.fake()

			local joystick = Joystick.new(
				--[[ configuration ]] configuration,
				--[[ currentCameraGetter ]] currentCameraGetter,
				--[[ guiService ]] guiService,
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] joysticksManager
			)

			expect(joystick.activationRegion).to.equal(configuration.activationRegion)
			expect(joystick.currentCameraGetter).to.equal(currentCameraGetter)
			expect(joystick.guiService).to.equal(guiService)
			expect(joystick.gutterCenterPoint).to.equal(configuration.inactiveCenterPoint)
			expect(joystick.gutterRadiusInPixels).to.equal(configuration.gutterRadiusInPixels)
			expect(joystick.isActive).to.equal(false)
			expect(joystick.isEnabled).to.equal(configuration.initializedEnabled)
			expect(joystick.isVisible).to.equal(configuration.initializedVisible)
			expect(joystick.joysticksManager).to.equal(joysticksManager)
			expect(joystick.priorityLevel).to.equal(configuration.priorityLevel)
			expect(joystick.relativeThumbRadius).to.equal(configuration.relativeThumbRadius)
			expect(joystick.renderer).to.equal(configuration.renderer)
		end)

		it("should be destroyable and all public and internal methods should throw", function()
			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] a.fake()
			)

			joystick:destroy()

			-- public methods
			expect(function()
				joystick:setActivationRegion(a.fake())
			end).to.throw()

			expect(function()
				joystick:setEnabled(true)
			end).to.throw()

			expect(function()
				joystick:setGutterRadiusInPixels(1)
			end).to.throw()

			expect(function()
				joystick:setInactiveCenterPoint(Vector2.new())
			end).to.throw()

			expect(function()
				joystick:setPriorityLevel(1)
			end).to.throw()

			expect(function()
				joystick:setRelativeThumbRadius(1)
			end).to.throw()

			expect(function()
				joystick:setRenderer(a.fake())
			end).to.throw()

			expect(function()
				joystick:setVisible(true)
			end).to.throw()

			-- internal methods
			expect(function()
				joystick.activate()
			end).to.throw()

			expect(function()
				joystick.deactivate()
			end).to.throw()

			expect(function()
				joystick.render(Instance.new("ScreenGui"))
			end).to.throw()

			expect(function()
				joystick.updateInput(Vector2.new())
			end).to.throw()
		end)

		it("should deregister with joysticksManager when destroyed", function()
			local joysticksManager = a.fake()

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] joysticksManager
			)

			joystick:destroy()

			expect(a.callTo(
				joysticksManager["deregisterJoystick"],
				joysticksManager,
				joystick
			):didHappen()).to.equal(true)
		end)

		it("should change activation regions", function()
			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] a.fake()
			)

			local newValue = a.fake()
			joystick:setActivationRegion(newValue)

			expect(joystick.activationRegion).to.equal(newValue)
		end)

		it("should change its enabled state", function()
			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] a.fake()
			)

			local newValue = false
			joystick:setEnabled(newValue)

			expect(joystick.isEnabled).to.equal(newValue)
		end)

		it("should change its gutter radius and request a render", function()
			local joysticksManager = a.fake()

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] joysticksManager
			)

			local newValue = math.floor(math.random() * 10) + 1
			joystick:setGutterRadiusInPixels(newValue)

			expect(joystick.gutterRadiusInPixels).to.equal(newValue)
			expect(a.callTo(
				joysticksManager["requestRender"],
				joysticksManager,
				joystick
			):didHappen()).to.equal(true)
		end)

		it("should change its inactive center point and gutter center point and request a render", function()
			local joysticksManager = a.fake()

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] joysticksManager
			)

			local newValue = Vector2.new(math.random(), math.random())
			joystick:setInactiveCenterPoint(newValue)

			expect(joystick.inactiveCenterPoint).to.equal(newValue)
			expect(joystick.gutterCenterPoint).to.equal(newValue)
			expect(a.callTo(
				joysticksManager["requestRender"],
				joysticksManager,
				joystick
			):didHappen()).to.equal(true)
		end)

		it("should change its priority level and request a render", function()
			local joysticksManager = a.fake()

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					priorityLevel = 1,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] joysticksManager
			)

			local newValue = 2
			joystick:setPriorityLevel(newValue)

			expect(joystick.priorityLevel).to.equal(newValue)
			expect(a.callTo(
				joysticksManager["requestRender"],
				joysticksManager,
				joystick
			):didHappen()).to.equal(true)
		end)

		it("should change its relative thumb radius and request a render", function()
			local joysticksManager = a.fake()

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] joysticksManager
			)

			local newValue = 1
			joystick:setRelativeThumbRadius(newValue)

			expect(joystick.relativeThumbRadius).to.equal(newValue)
			expect(a.callTo(
				joysticksManager["requestRender"],
				joysticksManager,
				joystick
			):didHappen()).to.equal(true)
		end)

		it("should change its renderer and request a render", function()
			local joysticksManager = a.fake()

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] joysticksManager
			)

			local newValue = a.fake()
			joystick:setRenderer(newValue)

			expect(joystick.renderer).to.equal(newValue)
			expect(a.callTo(
				joysticksManager["requestRender"],
				joysticksManager,
				joystick
			):didHappen()).to.equal(true)
		end)

		it("should change its visibility and request a render when changing visibility to true", function()
			local joysticksManager = a.fake()

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] joysticksManager
			)

			joystick:setVisible(false)

			expect(joystick.isVisible).to.equal(false)

			joystick:setVisible(true)

			expect(joystick.isVisible).to.equal(true)
			expect(a.callTo(
				joysticksManager["requestRender"],
				joysticksManager,
				joystick
			):didHappen()).to.equal(true)
		end)

		it("should set isActive to true, assigns correct value to input, and fire activated when activate is called on an inactive joystick", function()
			local function currentCameraGetter()
				local camera = a.fake()
				camera.ViewportSize = Vector2.new(1, 1)
				return camera
			end

			local guiService = a.fake()
			a.callTo(guiService["GetGuiInset"], guiService):returns(Vector2.new(), Vector2.new())

			local inputPoint = Vector2.new(math.random(), math.random())

			local joystickInputCalculator = a.fake()
			local expectedInput = Vector2.new(math.random(), math.random())
			a.callTo(
				joystickInputCalculator["calculate"],
				joystickInputCalculator,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				inputPoint):returns(expectedInput)

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] currentCameraGetter,
				--[[ guiService ]] guiService,
				--[[ joystickInputCalculator ]] joystickInputCalculator,
				--[[ joysticksManager ]] a.fake()
			)

			local wasActivatedFired = false

			joystick.activated:Connect(function()
				wasActivatedFired = true
			end)

			joystick:activate(inputPoint)

			wait()

			expect(joystick.isActive).to.equal(true)
			expect(joystick.input).to.be.ok()
			expect(joystick.input.X).to.be.near(expectedInput.X, 1 / 128)
			expect(joystick.input.Y).to.be.near(expectedInput.Y, 1 / 128)
			expect(wasActivatedFired).to.equal(true)
		end)

		it("should not fire activated when activate is called on an already activated joystick", function()
			local function currentCameraGetter()
				local camera = a.fake()
				camera.ViewportSize = Vector2.new(1, 1)
				return camera
			end

			local guiService = a.fake()
			a.callTo(guiService["GetGuiInset"], guiService):returns(Vector2.new(), Vector2.new())

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] currentCameraGetter,
				--[[ guiService ]] guiService,
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] a.fake()
			)

			joystick:activate(Vector2.new())

			local wasActivatedFired = false

			joystick.activated:Connect(function()
				wasActivatedFired = true
			end)

			joystick:activate(Vector2.new())

			wait()

			expect(wasActivatedFired).to.equal(false)
		end)

		it("should set isActive to false, set input to nil, and fire deactivated with the proper finalInput when deactivate is called on an activated joystick", function()
			local function currentCameraGetter()
				local camera = a.fake()
				camera.ViewportSize = Vector2.new(1, 1)
				return camera
			end

			local guiService = a.fake()
			a.callTo(guiService["GetGuiInset"], guiService):returns(Vector2.new(), Vector2.new())

			local inputPoint = Vector2.new(math.random(), math.random())

			local joystickInputCalculator = a.fake()
			local expectedInput = Vector2.new(math.random(), math.random())
			a.callTo(
				joystickInputCalculator["calculate"],
				joystickInputCalculator,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				inputPoint):returns(expectedInput)

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] currentCameraGetter,
				--[[ guiService ]] guiService,
				--[[ joystickInputCalculator ]] joystickInputCalculator,
				--[[ joysticksManager ]] a.fake()
			)

			joystick:activate(inputPoint)

			local wasDeactivatedFired = false
			local reportedFinalInput = nil

			joystick.deactivated:Connect(function(finalInput)
				wasDeactivatedFired = true
				reportedFinalInput = finalInput
			end)

			joystick:deactivate()

			wait()

			expect(joystick.isActive).to.equal(false)
			expect(joystick.input).never.to.be.ok()
			expect(wasDeactivatedFired).to.equal(true)
			expect(reportedFinalInput.X).to.be.near(expectedInput.X, 1 / 128)
			expect(reportedFinalInput.Y).to.be.near(expectedInput.Y, 1 / 128)
		end)

		it("should not fire deactivated when deactivate is called on an already inactive joystick", function()
			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] a.fake()
			)

			local wasDeactivatedFired = false

			joystick.deactivated:Connect(function()
				wasDeactivatedFired = true
			end)

			joystick:deactivate()

			wait()

			expect(wasDeactivatedFired).to.equal(false)
		end)

		it("should tell renderer to render when render is called", function()
			local renderer = a.fake()

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = renderer
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] a.fake()
			)

			joystick:render(a.fake())

			expect(a.callTo(
				renderer["render"],
				renderer,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard
			):didHappen()).to.equal(true)
		end)

		it("should give the renderer expected arguments from config when render is called", function()
			local renderer = a.fake()

			local configuration = {
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				priorityLevel = 1,
				relativeThumbRadius = 0.5,
				renderer = renderer
			}

			local joystick = Joystick.new(
				--[[ configuration ]] configuration,
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] a.fake()
			)

			local screenGui = a.fake()
			joystick:render(screenGui)

			expect(a.callTo(
				renderer["render"],
				renderer,
				configuration.inactiveCenterPoint,
				fitumi.wildcard,
				configuration.gutterRadiusInPixels,
				configuration.relativeThumbRadius,
				configuration.priorityLevel,
				screenGui
			):didHappen()).to.equal(true)
		end)

		it("should give the renderer a 0-Vector2 for the relativeThumbPosition when render is called on an inactive joystick", function()
			local renderer = a.fake()

			local wasRelativeThumbPositionZero = false
			renderer.render = function(self, _, relativeThumbPosition)
				wasRelativeThumbPositionZero = relativeThumbPosition.Magnitude == 0
			end

			local configuration = {
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				priorityLevel = 1,
				relativeThumbRadius = 0.5,
				renderer = renderer
			}

			local joystick = Joystick.new(
				--[[ configuration ]] configuration,
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] a.fake()
			)

			joystick:render(a.fake())

			expect(wasRelativeThumbPositionZero).to.equal(true)
		end)

		it("should give the renderer the expected relativeThumbPosition when render is called on an active joystick", function()
			local function currentCameraGetter()
				local camera = a.fake()
				camera.ViewportSize = Vector2.new(1, 1)
				return camera
			end

			local guiService = a.fake()
			a.callTo(guiService["GetGuiInset"], guiService):returns(Vector2.new(), Vector2.new())

			local joystickInputCalculator = a.fake()
			local expectedInput = Vector2.new(math.random(), math.random())
			a.callTo(
				joystickInputCalculator["calculate"],
				joystickInputCalculator,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard):returns(expectedInput)

			local renderer = a.fake()

			local providedRelativeThumbPosition = nil
			renderer.render = function(self, _, relativeThumbPosition)
				providedRelativeThumbPosition = relativeThumbPosition
			end

			local configuration = {
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				priorityLevel = 1,
				relativeThumbRadius = 0,
				renderer = renderer
			}

			local joystick = Joystick.new(
				--[[ configuration ]] configuration,
				--[[ currentCameraGetter ]] currentCameraGetter,
				--[[ guiService ]] guiService,
				--[[ joystickInputCalculator ]] joystickInputCalculator,
				--[[ joysticksManager ]] a.fake()
			)

			joystick:activate(Vector2.new())

			joystick:render(a.fake())

			expect(providedRelativeThumbPosition).to.be.ok()
			expect(providedRelativeThumbPosition.X).to.be.near(expectedInput.X, 1 / 128)
			expect(providedRelativeThumbPosition.Y).to.be.near(expectedInput.Y, 1 / 128)
		end)

		it("should update input appopriately and fire inputChanged with the expected new input when active", function()
			local function currentCameraGetter()
				local camera = a.fake()
				camera.ViewportSize = Vector2.new(1, 1)
				return camera
			end

			local guiService = a.fake()
			a.callTo(guiService["GetGuiInset"], guiService):returns(Vector2.new(), Vector2.new())

			local initialInputPoint = Vector2.new(math.random(), math.random())

			local joystickInputCalculator = a.fake()
			a.callTo(
				joystickInputCalculator["calculate"],
				joystickInputCalculator,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				initialInputPoint):returns(Vector2.new())

			local updatedInputPoint = Vector2.new(math.random(), math.random())
			local expectedUpdatedInput = Vector2.new(math.random(), math.random())
			a.callTo(
				joystickInputCalculator["calculate"],
				joystickInputCalculator,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				updatedInputPoint):returns(expectedUpdatedInput)

			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] currentCameraGetter,
				--[[ guiService ]] guiService,
				--[[ joystickInputCalculator ]] joystickInputCalculator,
				--[[ joysticksManager ]] a.fake()
			)

			joystick:activate(initialInputPoint)

			local wasInputChangedFired = false
			local reportedUpdatedInput = nil
			joystick.inputChanged:Connect(function(newInput)
				wasInputChangedFired = true
				reportedUpdatedInput = newInput
			end)

			wait()

			joystick:updateInput(updatedInputPoint)

			expect(joystick.input).to.be.ok()
			expect(joystick.input.X).to.be.near(expectedUpdatedInput.X, 1 / 128)
			expect(joystick.input.Y).to.be.near(expectedUpdatedInput.Y, 1 / 128)
			expect(wasInputChangedFired).to.equal(true)
			expect(reportedUpdatedInput).to.be.ok()
			expect(reportedUpdatedInput.X).to.be.near(expectedUpdatedInput.X, 1 / 128)
			expect(reportedUpdatedInput.Y).to.be.near(expectedUpdatedInput.Y, 1 / 128)
		end)

		it("should throw when attempting to change the input of an inactive joystick", function()
			local joystick = Joystick.new(
				{
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					relativeThumbRadius = 0.5,
					renderer = a.fake()
				},
				--[[ currentCameraGetter ]] a.fake,
				--[[ guiService ]] a.fake(),
				--[[ joystickInputCalculator ]] a.fake(),
				--[[ joysticksManager ]] a.fake()
			)

			expect(function()
				joystick:updateInput(Vector2.new())
			end).to.throw()
		end)
	end)
end
