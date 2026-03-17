local PhysicsService = game:GetService("PhysicsService")

local function assignToPlayerGroup(character)
	character.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			descendant.CollisionGroup = "Players"
		end
	end)
	
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			if part.CollisionGroup then
				part.CollisionGroup = "Players"
			end
		end
	end
end

-- Get the local player's character and assign it to the "Players" group
local player = game.Players.LocalPlayer
if player.Character then
	assignToPlayerGroup(player.Character)
end

-- Ensure character is added after death
player.CharacterAdded:Connect(function(character)
	task.wait(0.1)
	assignToPlayerGroup(character)
end)