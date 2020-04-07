return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local fitumi = require(ReplicatedStorage:WaitForChild("fitumi"))
    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local SolidFilledCircle = TS.import(script, ReplicatedStorage, "TS", "Implementation", "CompositeJoystickRenderer", "Components", "SolidFilledCircle").SolidFilledCircle;

	local a = fitumi.a

	local createFakeSignal = require(ReplicatedStorage.Tests.functions.createFakeSignal)
	local createNoopSignal = require(ReplicatedStorage.Tests.functions.createNoopSignal)

	-- TODO
end
