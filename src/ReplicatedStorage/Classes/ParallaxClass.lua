--!strict
local Class = {}
Class = Class.__index

Class.Instances = game.Workspace:WaitForChild("ParallaxInstances") -- TODO Make this work with CollectionService
Class.Portal = Class.Instances:WaitForChild("ParallaxInstance").MainParallax
Class.PortalGui = Class.Portal.PortalGui.Portal

local Connection

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

type LayerInfo = { position: UDim2, depth: number }

local layers: { [GuiObject]: LayerInfo } = {}

function addLayer(layer: any)
	if not layer:IsA("GuiObject") then
		return
	end

	layers[layer] = {
		position = layer.Position,
		depth = layer:GetAttribute("ParallaxDepth") or 0,
	}
end

function Class.AddParallax()
	Class.PortalGui.ChildAdded:Connect(addLayer)
	Connection = RunService.RenderStepped:Connect(function() --  pack it into one function
		local CurrentCamera = game.Workspace.CurrentCamera :: Camera

		local ParallaxRatio = Class.Portal.Size.Y / Class.Portal.Size.X
		local cameraDirection = (Class.Portal.Position - CurrentCamera.CFrame.Position).Unit
		local portalDirection = Class.Portal.CFrame:VectorToObjectSpace(cameraDirection)
		local correctedDirection = Vector3.new(portalDirection.X, portalDirection.Y / ParallaxRatio, 0)

		for layer, info in layers do
			local offset = UDim2.fromScale(correctedDirection.X * info.depth, correctedDirection.Y * info.depth)
			layer.Position = info.position + offset
		end
	end)

	for _, layer in Class.PortalGui:GetChildren() do
		addLayer(layer)
	end
end

function Class.StopParallax()
	Connection:Disconnect()
end

return Class
