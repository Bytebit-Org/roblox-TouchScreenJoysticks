return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local RectangleGuiWindowRegion = TS.import(script, ReplicatedStorage, "TS", "Implementation", "GuiWindowRegions", "RectangleGuiWindowRegion").RectangleGuiWindowRegion;

	describe("RectangleGuiWindowRegion", function()
		it("should be constructable and fulfill its interface", function()
			local rectangleGuiWindowRegion;

			expect(function()
				rectangleGuiWindowRegion = RectangleGuiWindowRegion.new(Vector2.new(0, 0), Vector2.new(1, 1))
			end).never.to.throw()

			expect(rectangleGuiWindowRegion.isPointInRegion).to.be.a("function")
		end)

		it("should correctly label points as in region or not", function()
			for _ = 1, 30 do
				local topLeft = Vector2.new((math.random() - 0.5) * 10, (math.random() - 0.5) * 10)
				local diagonal = Vector2.new((math.random() * 10) + 1, (math.random() * 10) + 1)
				local bottomRight = topLeft + diagonal
				local rectangleGuiWindowRegion = RectangleGuiWindowRegion.new(topLeft, bottomRight)

				local topRight = Vector2.new(bottomRight.X, topLeft.Y)
				local bottomLeft = Vector2.new(topLeft.X, bottomRight.Y)
				local center = topLeft + (diagonal * 0.5)

				-- In bounds, all four corners and center
				expect(rectangleGuiWindowRegion:isPointInRegion(topLeft)).to.equal(true)
				expect(rectangleGuiWindowRegion:isPointInRegion(topRight)).to.equal(true)
				expect(rectangleGuiWindowRegion:isPointInRegion(center)).to.equal(true)
				expect(rectangleGuiWindowRegion:isPointInRegion(bottomLeft)).to.equal(true)
				expect(rectangleGuiWindowRegion:isPointInRegion(bottomRight)).to.equal(true)

				-- Out of bounds, near top left
				expect(rectangleGuiWindowRegion:isPointInRegion(topLeft + Vector2.new(0, -1))).to.equal(false)
				expect(rectangleGuiWindowRegion:isPointInRegion(topLeft + Vector2.new(-1, 0))).to.equal(false)
				expect(rectangleGuiWindowRegion:isPointInRegion(topLeft + Vector2.new(-1, -1))).to.equal(false)

				-- Out of bounds, near top right
				expect(rectangleGuiWindowRegion:isPointInRegion(topRight + Vector2.new(0, -1))).to.equal(false)
				expect(rectangleGuiWindowRegion:isPointInRegion(topRight + Vector2.new(1, 0))).to.equal(false)
				expect(rectangleGuiWindowRegion:isPointInRegion(topRight + Vector2.new(1, -1))).to.equal(false)

				-- Out of bounds, near bottom left
				expect(rectangleGuiWindowRegion:isPointInRegion(bottomLeft + Vector2.new(0, 1))).to.equal(false)
				expect(rectangleGuiWindowRegion:isPointInRegion(bottomLeft + Vector2.new(-1, 0))).to.equal(false)
				expect(rectangleGuiWindowRegion:isPointInRegion(bottomLeft + Vector2.new(-1, 1))).to.equal(false)

				-- Out of bounds, near bottom right
				expect(rectangleGuiWindowRegion:isPointInRegion(bottomRight + Vector2.new(0, 1))).to.equal(false)
				expect(rectangleGuiWindowRegion:isPointInRegion(bottomRight + Vector2.new(1, 0))).to.equal(false)
				expect(rectangleGuiWindowRegion:isPointInRegion(bottomRight + Vector2.new(1, 1))).to.equal(false)
			end
		end)
	end)
end
