return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local fitumi = require(ReplicatedStorage:WaitForChild("fitumi"))
    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local CompositeJoystickRenderer = TS.import(script, ReplicatedStorage, "TS", "Implementation", "JoystickRenderers", "CompositeJoystickRenderer").CompositeJoystickRenderer;

	local a = fitumi.a

	local createFakeSignal = require(ReplicatedStorage.Tests.functions.createFakeSignal)
	local createNoopSignal = require(ReplicatedStorage.Tests.functions.createNoopSignal)

	-- TODO
end
