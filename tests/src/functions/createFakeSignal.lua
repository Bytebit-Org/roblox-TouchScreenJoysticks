return function ()
	local handlers = {}

	return {
		Connect = function(self, handlerFunction)
			table.insert(handlers, handlerFunction)
			return {
				Disconnect = function()
					local removeIndex = #handlers + 1

					for i = 1, #handlers do
						if handlers[i] == handlerFunction then
							removeIndex = i
							break
						end
					end

					table.remove(handlers, removeIndex)
				end
			}
		end,

		Fire = function(self, ...)
			for i = 1, #handlers do
				handlers[i](...)
			end
		end
	}
end
