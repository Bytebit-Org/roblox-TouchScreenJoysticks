return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local fitumi = require(ReplicatedStorage:WaitForChild("fitumi"))
    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local JoysticksManager = TS.import(script, ReplicatedStorage, "TS", "Implementation", "JoysticksManager").JoysticksManager;

	local a = fitumi.a

	local createFakeInputObject = require(ReplicatedStorage.Tests.functions.createFakeInputObject)
	local createFakeSignal = require(ReplicatedStorage.Tests.functions.createFakeSignal)

	function getJoystickCreateConfigurations()
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

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			local joysticksManager = nil
			expect(function ()
				joysticksManager = JoysticksManager.new(
					currentCameraGetter,
					guiService,
					screenGuisParent,
					userInputService
				)
			end).never.to.throw()

            expect(joysticksManager.createJoystick).to.be.a("function")
            expect(joysticksManager.destroyJoystick).to.be.a("function")
		end)

		it("should add and destroy joysticks", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				screenGuisParent,
				userInputService
			)

			local joysticks = {}
			local joystickConfigurations = getJoystickCreateConfigurations()
			for i = 1, #joystickConfigurations do
				expect(function()
					table.insert(joysticks, joysticksManager:createJoystick(joystickConfigurations[i]))
				end).never.to.throw()
			end

			for i = 1, #joysticks do
				expect(function()
					joysticksManager:destroyJoystick(joysticks[i])
				end).never.to.throw()
			end
		end)

		it("should throw when attempting to destroy a joystick from another manager", function()
			local currentCameraGetter = function ()
				return a.fake()
			end

			local guiService = a.fake()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = a.fake()

			local creatorJoysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				screenGuisParent,
				userInputService
			)
			local destroyerJoysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				screenGuisParent,
				userInputService
			)

			local joystick = creatorJoysticksManager:createJoystick({
				activationRegion = a.fake(),
				gutterRadiusInPixels = 10,
				inactiveCenterPoint = Vector2.new(0, 0),
				renderer = a.fake(),
				relativeThumbRadius = 0.5
			})

			expect(function()
				destroyerJoysticksManager:destroyJoystick(joystick)
			end).to.throw()
		end)
    end)
end
