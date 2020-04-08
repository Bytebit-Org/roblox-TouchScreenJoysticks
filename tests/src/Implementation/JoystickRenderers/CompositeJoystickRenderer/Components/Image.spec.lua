return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
	local Image = TS.import(script, ReplicatedStorage, "TS", "Implementation", "JoystickRenderers", "CompositeJoystickRenderer", "Components", "Image").Image

	local testAssetPath = "rbxassetid://4798571099"

	describe("Image CompositeJoystickRenderer Component", function()
		it("should be constructable and fulfill its interface", function()
			local image;

			expect(function()
				image = Image.new(testAssetPath, Color3.new(0, 0, 0), 0)
			end).never.to.throw()

			expect(image.destroy).to.be.a("function")
			expect(image.getParentableInstance).to.be.a("function")
			expect(image.hide).to.be.a("function")
			expect(image.render).to.be.a("function")
		end)

		it("should create a matching image label to its inputs", function()
			for _ = 1, 30 do
				local color = Color3.new(math.random(), math.random(), math.random())
				local transparency = math.random()
				local image = Image.new(testAssetPath, color, transparency)

				expect(image.imageLabel).to.be.ok()
				expect(image.imageLabel.Image).to.equal(testAssetPath)
				expect(image.imageLabel.ImageColor3).to.equal(color)
				expect(image.imageLabel.ImageTransparency).to.be.near(transparency, 1/128)
			end
		end)

		it("should be destroyable and all public methods should throw", function()
			local image = Image.new(testAssetPath, Color3.new(0, 0, 0), 0)

			image:destroy()

			expect(function()
				image:getParentableInstance()
			end).to.throw()

			expect(function()
				image:hide()
			end).to.throw()

			expect(function()
				image:render(
					--[[ position ]] UDim2.new(),
					--[[ size ]] UDim2.new(),
					--[[ zIndex ]] 1,
					--[[ parent ]] Instance.new("Folder")
				)
			end).to.throw()
		end)

		it("should return its own image label as the parentable instance", function()
			local image = Image.new(testAssetPath, Color3.new(0, 0, 0), 0)

			image:render(
				--[[ position ]] UDim2.new(),
				--[[ size ]] UDim2.new(),
				--[[ zIndex ]] 1,
				--[[ parent ]] Instance.new("Folder")
			)

			local parentableInstance = image:getParentableInstance()

			expect(parentableInstance).to.equal(image.imageLabel)
		end)

		it("should hide its image label by changing the parent to nil", function()
			local image = Image.new(testAssetPath, Color3.new(0, 0, 0), 0)

			image:render(
				--[[ position ]] UDim2.new(),
				--[[ size ]] UDim2.new(),
				--[[ zIndex ]] 1,
				--[[ parent ]] Instance.new("Folder")
			)

			image:hide()

			expect(image.imageLabel.Parent).never.to.be.ok()
		end)

		it("should render its image label by changing the properties as dictated", function()
			local image = Image.new(testAssetPath, Color3.new(0, 0, 0), 0)

			for _ = 1, 30 do
				local position = UDim2.new(math.random(), 0, math.random(), 0)
				local size = UDim2.new(math.random(), 0, math.random(), 0)
				local zIndex = math.floor(math.random() * 10) + 1
				local parent = Instance.new("Folder")

				image:render(
					--[[ position ]] position,
					--[[ size ]] size,
					--[[ zIndex ]] zIndex,
					--[[ parent ]] parent
				)

				expect(image.imageLabel.Position).to.equal(position)
				expect(image.imageLabel.Size).to.equal(size)
				expect(image.imageLabel.ZIndex).to.equal(zIndex)
				expect(image.imageLabel.Parent).to.equal(parent)
			end
		end)
	end)
end
