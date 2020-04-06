local ReplicatedStorage = game:GetService("ReplicatedStorage")

local createFakeSignal = require(ReplicatedStorage.Tests.functions.createFakeSignal)

return function ()
	return {
		TouchEnded = createFakeSignal(),
		TouchMoved = createFakeSignal(),
		TouchStarted = createFakeSignal()
	}
end
