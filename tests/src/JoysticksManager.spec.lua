return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local JoysticksManager = TS.import(script, ReplicatedStorage, "TS", "Implementation", "JoysticksManager").JoysticksManager;

	local createFakeCamera = require(ReplicatedStorage.Tests.functions.createFakeCamera)
	local createFakeGuiService = require(ReplicatedStorage.Tests.functions.createFakeGuiService)
	local createFakeInputObject = require(ReplicatedStorage.Tests.functions.createFakeInputObject)
	local createFakeUserInputService = require(ReplicatedStorage.Tests.functions.createFakeUserInputService)

    describe("JoysticksManager", function()
		it("should be safely instantiable and fulfill the interface", function()
			local currentCameraGetter = function ()
				return createFakeCamera()
			end
			local guiService = createFakeGuiService()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = createFakeUserInputService()

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

		it("register joysticks correctly", function()
			local currentCameraGetter = function ()
				return createFakeCamera()
			end
			local guiService = createFakeGuiService()
			local screenGuisParent = Instance.new("Folder")
			local userInputService = createFakeUserInputService()

			local joysticksManager = JoysticksManager.new(
				currentCameraGetter,
				guiService,
				screenGuisParent,
				userInputService
			)

            userInputService.TouchStarted:Fire(
                createFakeInputObject(),
                false
            )
        end)
    end)
end
