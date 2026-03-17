local ServerStorage = game:GetService("ServerStorage")

local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)
local Players = game:GetService("Players")

local tycoonPlotFolder = script.Parent

for _, tycoonPlot in ipairs(tycoonPlotFolder:GetChildren()) do
	if not tycoonPlot:IsA("Folder") then
		continue
	end
	
	local ownerTycoon = tycoonPlot.Tycoon
	local carSpawner = tycoonPlot:FindFirstChild("Car Spawner")
	local rallyCar = carSpawner.RallyCar
	
	local function attachOwnerOnlyEffect(child)
		if child.Name == "SeatWeld" then
			local player = Players:GetPlayerFromCharacter(child.Part1.Parent)
			local tycoonOfPlayer = TycoonOwnershipData.GetTycoon(player)
			if tycoonOfPlayer ~= ownerTycoon then
				player.Character.Humanoid.Health = 0
			end
		end
	end
	
	rallyCar.DriveSeat.ChildAdded:Connect(attachOwnerOnlyEffect)
	
	carSpawner.ChildAdded:Connect(function(child)
		if child.Name == "RallyCar" then
			child.DriveSeat.ChildAdded:Connect(attachOwnerOnlyEffect)
		end
	end)
end