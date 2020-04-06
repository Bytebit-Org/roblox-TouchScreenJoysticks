return function()
    local JoysticksManager = require(script.Parent.JoysticksManager)

    describe("test", function()
        it("should work", function()
            local joysticksManager = JoysticksManager.new()
            expect(#joysticksManager.joysticks).to.equal(1)
        end)
    end)
end