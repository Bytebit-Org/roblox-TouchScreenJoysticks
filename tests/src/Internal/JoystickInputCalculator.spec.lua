return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local JoystickInputCalculator = TS.import(script, ReplicatedStorage, "TS", "Internal", "JoystickInputCalculator").JoystickInputCalculator;

	describe("JoystickInputCalculator", function()
		it("should be constructable and fulfill its interface", function()
			local joystickInputCalculator;

			expect(function()
				joystickInputCalculator = JoystickInputCalculator.new()
			end).never.to.throw()

			expect(joystickInputCalculator.calculate).to.be.a("function")
		end)

		local function testCalculation(
			joystickInputCalculator,
			gutterCenterPoint,
			gutterRadiusInPixels,
			relativeThumbRadius,
			inputPoint,
			expectedResult)
			local actualResult = joystickInputCalculator:calculate(
				gutterCenterPoint,
				gutterRadiusInPixels,
				relativeThumbRadius,
				inputPoint
			)

			expect(actualResult).to.be.ok()
			expect(actualResult.X).to.be.near(expectedResult.X, 1 / 128)
			expect(actualResult.Y).to.be.near(expectedResult.Y, 1 / 128)
		end

		it("should calculate the expected input as the origin when inputPoint is 0 regardless of gutter center point, gutter radius, or relative thumb radius", function()
			local joystickInputCalculator = JoystickInputCalculator.new()

			for _ = 1, 30 do
				local gutterCenterPoint = Vector2.new(math.random() * 100, math.random() * 100)

				testCalculation(
					--[[ joystickInputCalculator ]] joystickInputCalculator,
					--[[ gutterCenterPoint ]] gutterCenterPoint,
					--[[ gutterRadiusInPixels ]] (math.random() * 10) + 1,
					--[[ relativeThumbRadius ]] math.random(),
					--[[ inputPoint ]] gutterCenterPoint + Vector2.new(),
					--[[ expectedResult ]] Vector2.new()
				)
			end
		end)

		it("should calculate the expected input on or past the edge of the base input circle regardless of gutter center point, gutter radius, or relative thumb radius", function()
			local joystickInputCalculator = JoystickInputCalculator.new()

			for _ = 1, 30 do
				local gutterCenterPoint = Vector2.new(math.random() * 100, math.random() * 100)
				local gutterRadiusInPixels = (math.random() * 10) + 1

				local theta = math.random() * 2*math.pi
				local unitCirclePoint = Vector2.new(math.cos(theta), math.sin(theta))

				testCalculation(
					--[[ joystickInputCalculator ]] joystickInputCalculator,
					--[[ gutterCenterPoint ]] gutterCenterPoint,
					--[[ gutterRadiusInPixels ]] gutterRadiusInPixels,
					--[[ relativeThumbRadius ]] math.random(),
					--[[ inputPoint ]] gutterCenterPoint + (unitCirclePoint * gutterRadiusInPixels),
					--[[ expectedResult ]] unitCirclePoint
				)
			end
		end)

		it("should calculate the expected input within the bounds of the base input circle regardless of gutter center point, gutter radius, or relative thumb radius", function()
			local joystickInputCalculator = JoystickInputCalculator.new()

			for _ = 1, 30 do
				local gutterCenterPoint = Vector2.new(math.random() * 100, math.random() * 100)
				local gutterRadiusInPixels = (math.random() * 10) + 1
				local relativeThumbRadius = (math.random() * 0.4) + 0.1

				local theta = math.random() * 2*math.pi
				local unitCirclePoint = Vector2.new(math.cos(theta), math.sin(theta))

				local baseInputCircleRadiusInPixels = gutterRadiusInPixels * (1 - relativeThumbRadius)
				local baseInputCircleRadiusPercentage = (math.random() * 0.9) + 0.05
				local inputDistanceFromGutterCenterPoint = baseInputCircleRadiusInPixels * baseInputCircleRadiusPercentage
				local relativeInputPoint = unitCirclePoint * inputDistanceFromGutterCenterPoint
				local expectedResult = unitCirclePoint * baseInputCircleRadiusPercentage

				testCalculation(
					--[[ joystickInputCalculator ]] joystickInputCalculator,
					--[[ gutterCenterPoint ]] gutterCenterPoint,
					--[[ gutterRadiusInPixels ]] gutterRadiusInPixels,
					--[[ relativeThumbRadius ]] relativeThumbRadius,
					--[[ inputPoint ]] gutterCenterPoint + relativeInputPoint,
					--[[ expectedResult ]] expectedResult
				)
			end
		end)
	end)
end
