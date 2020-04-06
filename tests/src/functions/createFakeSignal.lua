return function ()
	local bindableEvent = Instance.new("BindableEvent")

	return {
		Connect = function(self, handlerFunction)
			return bindableEvent.Event:Connect(handlerFunction)
		end,

		Fire = function(self, ...)
			bindableEvent:Fire(...)
		end
	}
end
