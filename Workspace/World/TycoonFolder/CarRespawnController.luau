local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)

local COOLDOWN = 2

local carPrefab = ReplicatedStorage:WaitForChild("RallyCar")

local tycoonPlotFolder = script.Parent

for _, tycoonPlot in ipairs(tycoonPlotFolder:GetChildren()) do
	if not tycoonPlot:IsA("Folder") then
		continue
	end
	
	local tycoon = tycoonPlot.Tycoon
	local carSpawner = tycoonPlot:WaitForChild("Car Spawner")
	local RespawnButton = carSpawner.RespawnButton
	local currentCar = carSpawner.RallyCar
	local carColor = currentCar.Body.MainBody.Color
	local startPivotPos = currentCar:GetPivot()
	
	local debounce = false
	
	RespawnButton.Touched:Connect(function(otherPart)
		if debounce then
			return
		end

		if not otherPart.Parent then
			return
		end
		local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
		if not player then
			return
		end
		if otherPart ~= player.Character.HumanoidRootPart then
			return
		end
		local tycoonOwner = TycoonOwnershipData.GetPlayerFromTycoon(tycoon)
		if player ~= tycoonOwner then
			return
		end
		if currentCar and currentCar.Parent then
			currentCar:Destroy()
		end
		currentCar = carPrefab:Clone()
		currentCar.Body.MainBody.Color = carColor
		currentCar.Parent = script.Parent
		currentCar:PivotTo(startPivotPos)
		debounce = true
		task.wait(COOLDOWN)
		debounce = false
	end)
end