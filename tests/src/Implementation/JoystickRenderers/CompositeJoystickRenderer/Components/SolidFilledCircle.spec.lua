return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
	local SolidFilledCircle = TS.import(script, ReplicatedStorage, "TS", "Implementation", "JoystickRenderers", "CompositeJoystickRenderer", "Components", "SolidFilledCircle").SolidFilledCircle

	describe("SolidFilledCicle CompositeJoystickRenderer Component", function()
		it("should be constructable and fulfill its interface", function()
			local solidFilledCircle;

			expect(function()
				solidFilledCircle = SolidFilledCircle.new(Color3.new(0, 0, 0), 0)
			end).never.to.throw()

			expect(solidFilledCircle.destroy).to.be.a("function")
			expect(solidFilledCircle.getParentableInstance).to.be.a("function")
			expect(solidFilledCircle.hide).to.be.a("function")
			expect(solidFilledCircle.render).to.be.a("function")
		end)

		it("should create a matching image label to its inputs", function()
			for _ = 1, 30 do
				local color = Color3.new(math.random(), math.random(), math.random())
				local transparency = math.random()
				local solidFilledCircle = SolidFilledCircle.new(color, transparency)

				expect(solidFilledCircle.imageLabel).to.be.ok()
				expect(solidFilledCircle.imageLabel.ImageColor3).to.equal(color)
				expect(solidFilledCircle.imageLabel.ImageTransparency).to.be.near(transparency, 1/128)
			end
		end)

		it("should be destroyable and all public methods should throw", function()
			local solidFilledCircle = SolidFilledCircle.new(Color3.new(0, 0, 0), 0)

			solidFilledCircle:destroy()

			expect(function()
				solidFilledCircle:getParentableInstance()
			end).to.throw()

			expect(function()
				solidFilledCircle:hide()
			end).to.throw()

			expect(function()
				solidFilledCircle:render(
					--[[ position ]] UDim2.new(),
					--[[ size ]] UDim2.new(),
					--[[ zIndex ]] 1,
					--[[ parent ]] Instance.new("Folder")
				)
			end).to.throw()
		end)

		it("should return its own image label as the parentable instance", function()
			local solidFilledCircle = SolidFilledCircle.new(Color3.new(0, 0, 0), 0)

			solidFilledCircle:render(
				--[[ position ]] UDim2.new(),
				--[[ size ]] UDim2.new(),
				--[[ zIndex ]] 1,
				--[[ parent ]] Instance.new("Folder")
			)

			local parentableInstance = solidFilledCircle:getParentableInstance()

			expect(parentableInstance).to.equal(solidFilledCircle.imageLabel)
		end)

		it("should hide its image label by changing the parent to nil", function()
			local solidFilledCircle = SolidFilledCircle.new(Color3.new(0, 0, 0), 0)

			solidFilledCircle:render(
				--[[ position ]] UDim2.new(),
				--[[ size ]] UDim2.new(),
				--[[ zIndex ]] 1,
				--[[ parent ]] Instance.new("Folder")
			)

			solidFilledCircle:hide()

			expect(solidFilledCircle.imageLabel.Parent).never.to.be.ok()
		end)

		it("should render its image label by changing the properties as dictated", function()
			local solidFilledCircle = SolidFilledCircle.new(Color3.new(0, 0, 0), 0)

			for _ = 1, 30 do
				local position = UDim2.new(math.random(), 0, math.random(), 0)
				local size = UDim2.new(math.random(), 0, math.random(), 0)
				local zIndex = math.floor(math.random() * 10) + 1
				local parent = Instance.new("Folder")

				solidFilledCircle:render(
					--[[ position ]] position,
					--[[ size ]] size,
					--[[ zIndex ]] zIndex,
					--[[ parent ]] parent
				)

				expect(solidFilledCircle.imageLabel.Position).to.equal(position)
				expect(solidFilledCircle.imageLabel.Size).to.equal(size)
				expect(solidFilledCircle.imageLabel.ZIndex).to.equal(zIndex)
				expect(solidFilledCircle.imageLabel.Parent).to.equal(parent)
			end
		end)
	end)
end
