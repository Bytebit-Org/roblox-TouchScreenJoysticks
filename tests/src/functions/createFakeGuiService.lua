return function (props, guiInset)
	return {
		GetGuiInset = function(self)
			return guiInset or { Vector2.new(0, 0), Vector2.new(0, 0) }
		end
	}
end
