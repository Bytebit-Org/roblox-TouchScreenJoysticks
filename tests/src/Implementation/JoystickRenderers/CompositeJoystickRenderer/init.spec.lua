return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local fitumi = require(ReplicatedStorage:WaitForChild("fitumi"))
    local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
	local CompositeJoystickRenderer = TS.import(script, ReplicatedStorage, "TS", "Implementation", "JoystickRenderers", "CompositeJoystickRenderer").CompositeJoystickRenderer;

	local a = fitumi.a

	describe("CompositeJoystickRenderer", function()
		it("should be constructable and fulfill its interface", function()
			local compositeJoystickRenderer;

			local gutterComponent = a.fake()
			local thumbComponent = a.fake()

			expect(function()
				compositeJoystickRenderer = CompositeJoystickRenderer.new(gutterComponent, thumbComponent)
			end).never.to.throw()

			expect(compositeJoystickRenderer.destroy).to.be.a("function")
			expect(compositeJoystickRenderer.hide).to.be.a("function")
			expect(compositeJoystickRenderer.render).to.be.a("function")
		end)

		it("should be destroyable and all public methods should throw", function()
			local gutterComponent = a.fake()
			local thumbComponent = a.fake()
			local compositeJoystickRenderer = CompositeJoystickRenderer.new(gutterComponent, thumbComponent)

			compositeJoystickRenderer:destroy()

			expect(function()
				compositeJoystickRenderer:hide()
			end).to.throw()

			expect(function()
				compositeJoystickRenderer:render(
					--[[ absoluteCenter ]] Vector2.new(),
					--[[ relativeThumbPosition ]]Vector2.new(),
					--[[ gutterRadiusInPixels ]] 1,
					--[[ relativeThumbRadius ]] 0.5,
					--[[ zIndex ]] 1,
					--[[ parent ]] a.fake()
				)
			end).to.throw()
		end)

		it("should be destroyable and destroy its components", function()
			local gutterComponent = a.fake()
			local thumbComponent = a.fake()
			local compositeJoystickRenderer = CompositeJoystickRenderer.new(gutterComponent, thumbComponent)

			compositeJoystickRenderer:destroy()

			expect(a.callTo(gutterComponent["destroy"], gutterComponent):didHappen()).to.equal(true)
			expect(a.callTo(thumbComponent["destroy"], thumbComponent):didHappen()).to.equal(true)
		end)

		it("should hide its components", function()
			local gutterComponent = a.fake()
			local thumbComponent = a.fake()
			local compositeJoystickRenderer = CompositeJoystickRenderer.new(gutterComponent, thumbComponent)

			compositeJoystickRenderer:hide()

			expect(a.callTo(gutterComponent["hide"], gutterComponent):didHappen()).to.equal(true)
			expect(a.callTo(thumbComponent["hide"], thumbComponent):didHappen()).to.equal(true)
		end)

		it("should render its components", function()
			local gutterComponent = a.fake()
			local thumbComponent = a.fake()
			local compositeJoystickRenderer = CompositeJoystickRenderer.new(gutterComponent, thumbComponent)

			compositeJoystickRenderer:render(
				--[[ absoluteCenter ]] Vector2.new(),
				--[[ relativeThumbPosition ]]Vector2.new(),
				--[[ gutterRadiusInPixels ]] 1,
				--[[ relativeThumbRadius ]] 0.5,
				--[[ zIndex ]] 1,
				--[[ parent ]] a.fake()
			)

			expect(a.callTo(
				gutterComponent["render"],
				gutterComponent,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard):didHappen()).to.equal(true)
			expect(a.callTo(
				thumbComponent["render"],
				thumbComponent,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard,
				fitumi.wildcard):didHappen()).to.equal(true)
		end)

		it("should render its gutter component properly", function()
			local gutterComponent = a.fake()
			local thumbComponent = a.fake()
			local compositeJoystickRenderer = CompositeJoystickRenderer.new(gutterComponent, thumbComponent)

			local renderCallArgs = nil
			gutterComponent.render = function(self, position, size, zIndex, parent)
				renderCallArgs = {
					position = position,
					size = size,
					zIndex = zIndex,
					parent = parent
				}
			end

			local absoluteCenter = Vector2.new()
			local gutterRadiusInPixels = 1
			local zIndex = 1
			local parent = a.fake()

			compositeJoystickRenderer:render(
				--[[ absoluteCenter ]] absoluteCenter,
				--[[ relativeThumbPosition ]]Vector2.new(),
				--[[ gutterRadiusInPixels ]] gutterRadiusInPixels,
				--[[ relativeThumbRadius ]] 0.5,
				--[[ zIndex ]] zIndex,
				--[[ parent ]] parent
			)

			expect(renderCallArgs).to.be.ok()

			expect(renderCallArgs.position.X.Offset).to.equal(absoluteCenter.X)
			expect(renderCallArgs.position.Y.Offset).to.equal(absoluteCenter.Y)

			expect(renderCallArgs.size.X.Offset).to.equal(gutterRadiusInPixels * 2)
			expect(renderCallArgs.size.Y.Offset).to.equal(gutterRadiusInPixels * 2)

			expect(renderCallArgs.zIndex).to.equal(zIndex)

			expect(renderCallArgs.parent).to.equal(parent)
		end)

		it("should render its thumb component properly", function()
			local gutterComponent = a.fake()
			local thumbComponent = a.fake()
			local compositeJoystickRenderer = CompositeJoystickRenderer.new(gutterComponent, thumbComponent)

			local thumbParent = a.fake()

			a.callTo(gutterComponent["getParentableInstance"], gutterComponent):returns(thumbParent)

			for _ = 1, 30 do
				local renderCallArgs = nil
				thumbComponent.render = function(self, position, size, _, parent)
					renderCallArgs = {
						position = position,
						size = size,
						parent = parent
					}
				end

				local theta = math.pi - (math.random() * 2*math.pi)
				local relativeThumbPosition = Vector2.new(math.cos(theta), math.sin(theta))
				local relativeThumbRadius = 0.5

				compositeJoystickRenderer:render(
					--[[ absoluteCenter ]] Vector2.new(),
					--[[ relativeThumbPosition ]] relativeThumbPosition,
					--[[ gutterRadiusInPixels ]] 1,
					--[[ relativeThumbRadius ]] relativeThumbRadius,
					--[[ zIndex ]] 1,
					--[[ parent ]] a.fake()
				)

				expect(renderCallArgs).to.be.ok()

				local renderedThumbPosition = Vector2.new(renderCallArgs.position.X.Scale, renderCallArgs.position.Y.Scale)
				local renderedUnitCircleThumbPosition = renderedThumbPosition - Vector2.new(0.5, 0.5)
				local renderedTheta = math.atan2(renderedUnitCircleThumbPosition.Y, renderedUnitCircleThumbPosition.X)
				expect(renderedTheta).to.be.near(theta, 1 / 128)

				expect(renderCallArgs.size.X.Scale).to.equal(relativeThumbRadius)
				expect(renderCallArgs.size.Y.Scale).to.equal(relativeThumbRadius)

				expect(renderCallArgs.parent).to.equal(thumbParent)
			end
		end)
	end)
end
