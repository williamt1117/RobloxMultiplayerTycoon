local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local OverheadLevelGui = ReplicatedStorage.OverheadLevelGui

local function addOverheadLevel(character)
	local clone = OverheadLevelGui:Clone()
	game.Workspace:WaitForChild(character.Name)
	clone.Parent = character:WaitForChild("Head")
	clone.Adornee = character:WaitForChild("Head")
end

for _, player in ipairs(Players:GetChildren()) do
	local character = player.Character or player.CharacterAdded:Wait()
	addOverheadLevel(character)
	
	player.CharacterAdded:Connect(function(character)
		addOverheadLevel(character)
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		addOverheadLevel(character)
	end)
end)
