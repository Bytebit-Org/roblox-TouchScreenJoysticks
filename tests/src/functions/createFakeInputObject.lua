return function (props, modifierKeys)
    return {
        Delta = props and props.Delta or Vector2.new(0, 0),
        KeyCode = props and props.KeyCode or Enum.KeyCode.Unknown,
        Position = props and props.Position or Vector3.new(0, 0, 0),
        UserInputState = props and props.UserInputState or "None",
        UserInputType = props and props.UserInputType or "None",

        IsModifierKeyDown = function(self, modifierKey)
            return modifierKeys and modifierKeys[modifierKey] == true or false
        end
    }
end
