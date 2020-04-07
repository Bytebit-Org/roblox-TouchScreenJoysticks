local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fitumi = require(ReplicatedStorage:WaitForChild("fitumi"))

local a = fitumi.a

return function()
	local noopSignal = a.fake()
	a.callTo(noopSignal, "Connect", noopSignal, fitumi.wildcard):returns(a.fake())
	return noopSignal
end
