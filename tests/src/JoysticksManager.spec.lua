return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local fitumi = require(ReplicatedStorage:WaitForChild("fitumi"))
    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local JoysticksManager = TS.import(script, ReplicatedStorage, "TS", "Implementation", "JoysticksManager").JoysticksManager;

	local a = fitumi.a

	local createFakeInputObject = require(ReplicatedStorage.Tests.functions.createFakeInputObject)
	local createFakeSignal = require(ReplicatedStorage.Tests.functions.createFakeSignal)

	local function createNoopSignal()
		local noopSignal = a.fake()
		a.callTo(noopSignal, "Connect", noopSignal, fitumi.wildcard):returns(a.fake())
		return noopSignal
	end

	local function instantiateJoystickFromConfig(config)
		local joystick = a.fake()

		joystick.activationRegion = config.activationRegion
		joystick.isActive = false
		joystick.isEnabled = config.initializedEnabled
		joystick.isVisible = config.initializedVisible
		joystick.priorityLevel = config.priorityLevel or 1

		return joystick
	end

	local function getJoystickCreateConfigurations()
		return {
			{
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = false,
				initializedVisible = false,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			},
			{
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = false,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			},
			{
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = false,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			},
			{
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			}
		}
	end

    describe("JoysticksManager", function()
		it("should be constructable and fulfill its interface", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local joystickInstantiator = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createNoopSignal()

			local joysticksManager = nil
			expect(function ()
				joysticksManager = JoysticksManager.new(
					currentCameraGetter,
					guiService,
					joystickInstantiator,
					screenGuisParent,
					userInputService
				)
			end).never.to.throw()

            expect(joysticksManager.createJoystick).to.be.a("function")
            expect(joysticksManager.destroy).to.be.a("function")
		end)

		it("should create joysticks", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local joystickInstantiator = function ()
				local joystick = a.fake()
				joystick.priorityLevel = 1
				return joystick
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createNoopSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				joystickInstantiator,
				screenGuisParent,
				userInputService
			)

			local joystickConfigurations = getJoystickCreateConfigurations()
			for i = 1, #joystickConfigurations do
				expect(function()
					joysticksManager:createJoystick(joystickConfigurations[i])
				end).never.to.throw()
			end
		end)

		it("should render joysticks when created", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local joystickInstantiator = function(config)
				local joystick = instantiateJoystickFromConfig(config)
				fitumi.spy(joystick, "render")
				return joystick
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createFakeSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				joystickInstantiator,
				screenGuisParent,
				userInputService
			)

			local activationRegion = a.fake()
			a.callTo(activationRegion, "isPointInRegion", activationRegion, fitumi.wildcard):returns(true)

			local joystick = joysticksManager:createJoystick({
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			})

			expect(a.callTo(joystick, "render", joystick, fitumi.wildcard):didHappen()).to.equal(true)
		end)

		it("should be destroyable and all public methods should throw", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local joystickInstantiator = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createNoopSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				joystickInstantiator,
				screenGuisParent,
				userInputService
			)

			joysticksManager:destroy();

			expect(function()
				joysticksManager:createJoystick({
					activationRegion = a.fake(),
					gutterRadiusInPixels = 10,
					inactiveCenterPoint = Vector2.new(0, 0),
					initializedEnabled = true,
					initializedVisible = true,
					renderer = a.fake(),
					relativeThumbRadius = 0.5
				})
			end).to.throw()
		end)

		it("should be destroyable and clean up all its signal connections and delete all its screen guis", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local joystickInstantiator = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = a.fake()
			local touchEndedConnection = a.fake()
			fitumi.spy(touchEndedConnection, "Disconnect")
			a.callTo(userInputService.TouchEnded, "Connect", userInputService.TouchEnded, fitumi.wildcard):returns(touchEndedConnection)

			userInputService.TouchMoved = a.fake()
			local touchMovedConnection = a.fake()
			fitumi.spy(touchMovedConnection, "Disconnect")
			a.callTo(userInputService.TouchMoved, "Connect", userInputService.TouchMoved, fitumi.wildcard):returns(touchMovedConnection)

			userInputService.TouchStarted = a.fake()
			local touchStartedConnection = a.fake()
			fitumi.spy(touchStartedConnection, "Disconnect")
			a.callTo(userInputService.TouchStarted, "Connect", userInputService.TouchStarted, fitumi.wildcard):returns(touchStartedConnection)

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				joystickInstantiator,
				screenGuisParent,
				userInputService
			)

			joysticksManager:destroy()

			expect(a.callTo(touchEndedConnection, "Disconnect", touchEndedConnection):didHappen()).to.equal(true)
			expect(a.callTo(touchMovedConnection, "Disconnect", touchMovedConnection):didHappen()).to.equal(true)
			expect(a.callTo(touchStartedConnection, "Disconnect", touchStartedConnection):didHappen()).to.equal(true)
			expect(#screenGuisParent:GetChildren()).to.equal(0)
		end)

		local function testSingleJoystickActivation(isEnabled, isVisible, expectedIsActiveValue)
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createFakeSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				instantiateJoystickFromConfig,
				screenGuisParent,
				userInputService
			)

			local activationRegion = a.fake()
			a.callTo(activationRegion, "isPointInRegion", activationRegion, fitumi.wildcard):returns(true)

			local joystick = joysticksManager:createJoystick({
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = isEnabled,
				initializedVisible = isVisible,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			})

			fitumi.spy(joystick, "activate")

			userInputService.TouchStarted:Fire(createFakeInputObject(), false)

			if expectedIsActiveValue then
				expect(a.callTo(joystick, "activate", joystick, fitumi.wildcard):didHappen()).to.equal(true)
			else
				expect(a.callTo(joystick, "activate", joystick, fitumi.wildcard):didNotHappen()).to.equal(true)
			end
		end

		it("should activate the appropriate joystick when there is only one", function()
			testSingleJoystickActivation(true, true, true)
		end)

		it("should activate an enabled but invisible joystick", function()
			testSingleJoystickActivation(true, false, true)
		end)

		it("should not activate a disabled joystick", function()
			testSingleJoystickActivation(false, true, false)
		end)

		it("should render joysticks when activated", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createFakeSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				instantiateJoystickFromConfig,
				screenGuisParent,
				userInputService
			)

			local activationRegion = a.fake()
			a.callTo(activationRegion, "isPointInRegion", activationRegion, fitumi.wildcard):returns(true)

			local joystick = joysticksManager:createJoystick({
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			})

			fitumi.spy(joystick, "activate")
			fitumi.spy(joystick, "render")

			userInputService.TouchStarted:Fire(createFakeInputObject(), false)

			expect(a.callTo(joystick, "activate", joystick, fitumi.wildcard):didHappen()).to.equal(true)
			expect(a.callTo(joystick, "render", joystick, fitumi.wildcard):didHappen()).to.equal(true)
		end)

		local function testTwoJoysticksActivation(shouldActivateJoystickConfig, shouldNotActivateJoystickConfig)
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createFakeSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				instantiateJoystickFromConfig,
				screenGuisParent,
				userInputService
			)

			local shouldActivateJoystick = joysticksManager:createJoystick(shouldActivateJoystickConfig)
			fitumi.spy(shouldActivateJoystick, "activate")

			local shouldNotActivateJoystick = joysticksManager:createJoystick(shouldNotActivateJoystickConfig)
			fitumi.spy(shouldNotActivateJoystick, "activate")

			userInputService.TouchStarted:Fire(createFakeInputObject(), false)

			expect(a.callTo(shouldActivateJoystick, "activate", shouldActivateJoystick, fitumi.wildcard):didHappen()).to.equal(true)
			expect(a.callTo(shouldNotActivateJoystick, "activate", shouldNotActivateJoystick, fitumi.wildcard):didNotHappen()).to.equal(true)
		end

		it("should activate only joysticks where the touch starts in the appropriate region", function()
			local returnsTrueActivationRegion = a.fake()
			a.callTo(returnsTrueActivationRegion, "isPointInRegion", returnsTrueActivationRegion, fitumi.wildcard):returns(true)

			local returnsFalseActivationRegion = a.fake()
			a.callTo(returnsFalseActivationRegion, "isPointInRegion", returnsFalseActivationRegion, fitumi.wildcard):returns(false)

			local shouldActivateJoystickConfig = {
				activationRegion = returnsTrueActivationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			}

			local shouldNotActivateJoystickConfig = {
				activationRegion = returnsFalseActivationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			}

			testTwoJoysticksActivation(shouldActivateJoystickConfig, shouldNotActivateJoystickConfig)
		end)

		it("should activate only the highest priority joystick when a touch starts at an overlapping point", function()
			local activationRegion = a.fake()
			a.callTo(activationRegion, "isPointInRegion", activationRegion, fitumi.wildcard):returns(true)

			local shouldActivateJoystickConfig = {
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				priorityLevel = 2,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			}

			local shouldNotActivateJoystickConfig = {
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				priorityLevel = 1,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			}

			testTwoJoysticksActivation(shouldActivateJoystickConfig, shouldNotActivateJoystickConfig)
		end)

		it("should not activate a disabled joystick with higher priority when a touch starts at an overlapping point", function()
			local activationRegion = a.fake()
			a.callTo(activationRegion, "isPointInRegion", activationRegion, fitumi.wildcard):returns(true)

			local shouldActivateJoystickConfig = {
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				priorityLevel = 1,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			}

			local shouldNotActivateJoystickConfig = {
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = false,
				initializedVisible = true,
				priorityLevel = 2,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			}

			testTwoJoysticksActivation(shouldActivateJoystickConfig, shouldNotActivateJoystickConfig)
		end)

		it("should update joystick inputs when their touches move", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createFakeSignal()
			userInputService.TouchStarted = createFakeSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				instantiateJoystickFromConfig,
				screenGuisParent,
				userInputService
			)

			local activationRegion = a.fake()
			a.callTo(activationRegion, "isPointInRegion", activationRegion, fitumi.wildcard):returns(true)

			local joystick = joysticksManager:createJoystick({
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			})

			local inputObject = createFakeInputObject()

			userInputService.TouchStarted:Fire(inputObject, false)
			joystick.isActive = true

			fitumi.spy(joystick, "updateInput")

			userInputService.TouchMoved:Fire(inputObject)

			expect(a.callTo(joystick, "updateInput", joystick, fitumi.wildcard):didHappen()).to.equal(true)
		end)

		it("should render joystick inputs when their touches move", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createFakeSignal()
			userInputService.TouchStarted = createFakeSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				instantiateJoystickFromConfig,
				screenGuisParent,
				userInputService
			)

			local activationRegion = a.fake()
			a.callTo(activationRegion, "isPointInRegion", activationRegion, fitumi.wildcard):returns(true)

			local joystick = joysticksManager:createJoystick({
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			})

			local inputObject = createFakeInputObject()

			userInputService.TouchStarted:Fire(inputObject, false)
			joystick.isActive = true

			fitumi.spy(joystick, "render")

			userInputService.TouchMoved:Fire(inputObject)

			expect(a.callTo(joystick, "render", joystick, fitumi.wildcard):didHappen()).to.equal(true)
		end)

		it("should deactivate joysticks when their touches end", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createFakeSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createFakeSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				instantiateJoystickFromConfig,
				screenGuisParent,
				userInputService
			)

			local activationRegion = a.fake()
			a.callTo(activationRegion, "isPointInRegion", activationRegion, fitumi.wildcard):returns(true)

			local joystick = joysticksManager:createJoystick({
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			})

			local inputObject = createFakeInputObject()

			userInputService.TouchStarted:Fire(inputObject, false)
			joystick.isActive = true

			fitumi.spy(joystick, "deactivate")

			userInputService.TouchEnded:Fire(inputObject)

			expect(a.callTo(joystick, "deactivate", joystick):didHappen()).to.equal(true)
		end)

		it("should render joysticks when their touches end", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createFakeSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createFakeSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				instantiateJoystickFromConfig,
				screenGuisParent,
				userInputService
			)

			local activationRegion = a.fake()
			a.callTo(activationRegion, "isPointInRegion", activationRegion, fitumi.wildcard):returns(true)

			local joystick = joysticksManager:createJoystick({
				activationRegion = activationRegion,
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			})

			local inputObject = createFakeInputObject()

			userInputService.TouchStarted:Fire(inputObject, false)
			joystick.isActive = true

			fitumi.spy(joystick, "render")

			userInputService.TouchEnded:Fire(inputObject)

			expect(a.callTo(joystick, "render", joystick, fitumi.wildcard):didHappen()).to.equal(true)
		end)

		it("should render joysticks when they request a render", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			userInputService.TouchEnded = createNoopSignal()
			userInputService.TouchMoved = createNoopSignal()
			userInputService.TouchStarted = createNoopSignal()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				instantiateJoystickFromConfig,
				screenGuisParent,
				userInputService
			)

			local joystick = joysticksManager:createJoystick({
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				initializedEnabled = true,
				initializedVisible = true,
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			})

			fitumi.spy(joystick, "render")

			joysticksManager:requestRender(joystick)

			wait()
			wait()

			expect(a.callTo(joystick, "render", joystick, fitumi.wildcard):didHappen()).to.equal(true)
		end)
    end)
end
