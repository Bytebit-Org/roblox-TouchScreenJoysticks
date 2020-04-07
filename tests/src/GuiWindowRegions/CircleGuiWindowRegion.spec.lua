return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local CircleGuiWindowRegion = TS.import(script, ReplicatedStorage, "TS", "Implementation", "GuiWindowRegions", "CircleGuiWindowRegion").CircleGuiWindowRegion;

	describe("CircleGuiWindowRegion", function()
		it("should be constructable and fulfill its interface", function()
			local circleGuiWindowRegion;

			expect(function()
				circleGuiWindowRegion = CircleGuiWindowRegion.new(Vector2.new(0, 0), 0)
			end).never.to.throw()

			expect(circleGuiWindowRegion.isPointInRegion).to.be.a("function")
		end)

		it("should correctly label points as in region or not", function()
			for _ = 1, 30 do
				local origin = Vector2.new((math.random() - 0.5) * 10, (math.random() - 0.5) * 10)
				local radius = (math.random() * 10) + 1
				local circleGuiWindowRegion = CircleGuiWindowRegion.new(origin, radius)

				local theta = math.random() * 2*math.pi
				local unitCirclePoint = Vector2.new(math.cos(theta), math.sin(theta))

				expect(circleGuiWindowRegion:isPointInRegion(origin + (unitCirclePoint * radius * -2))).to.equal(false)
				expect(circleGuiWindowRegion:isPointInRegion(origin + (unitCirclePoint * radius * -(510 / 512)))).to.equal(true)
				expect(circleGuiWindowRegion:isPointInRegion(origin + (unitCirclePoint * radius * -0.5))).to.equal(true)
				expect(circleGuiWindowRegion:isPointInRegion(origin + (unitCirclePoint * radius * 0))).to.equal(true)
				expect(circleGuiWindowRegion:isPointInRegion(origin + (unitCirclePoint * radius * 0.5))).to.equal(true)
				expect(circleGuiWindowRegion:isPointInRegion(origin + (unitCirclePoint * radius * (510 / 512)))).to.equal(true)
				expect(circleGuiWindowRegion:isPointInRegion(origin + (unitCirclePoint * radius * 2))).to.equal(false)
			end
		end)
	end)
end
