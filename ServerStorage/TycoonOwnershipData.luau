local TycoonOwnershipData = {}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local TycoonFolder = Workspace:WaitForChild("World").TycoonFolder

-- Returns true if tycoon is successfully claimed, else returns false
function TycoonOwnershipData.AttemptClaim(player, tycoon)
	if TycoonOwnershipData[player.UserId] ~= nil then
		return false
	end
	
	TycoonOwnershipData[player.UserId] = tycoon
	return true
end

function TycoonOwnershipData.GetTycoon(player)
	return TycoonOwnershipData[player.UserId]
end

function TycoonOwnershipData.RemoveClaim(player)
	TycoonOwnershipData[player.userId] = nil
end

function TycoonOwnershipData.GetPlayerFromTycoon(targetTycoon)
	for userId, tycoon in pairs(TycoonOwnershipData) do
		if tycoon == targetTycoon then
			return Players:GetPlayerByUserId(userId)
		end
	end
	return nil  -- Return nil if no player owns this tycoon
end

function TycoonOwnershipData.TeleportToTycoon(player)
	local tycoon = TycoonOwnershipData.GetTycoon(player)
	if not tycoon then
		local potentialTycoons = {}
		for _, tycoonPlot in ipairs(TycoonFolder:GetChildren()) do
			if not tycoonPlot:IsA("Folder") then
				continue
			end
			local potentialTycoon = tycoonPlot:WaitForChild("Tycoon")
			if not TycoonOwnershipData.GetPlayerFromTycoon(potentialTycoon) then
				table.insert(potentialTycoons, potentialTycoon)
			end
		end
		
		local r = math.random() * #potentialTycoons
		tycoon = potentialTycoons[math.ceil(r)]
	end
	
	--teleport player to tycoon
	local tpLocation = tycoon:WaitForChild("TycoonSpawnPosition")
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChild("Humanoid")
	
	if humanoid.SeatPart then
		humanoid.Jump = true
		task.wait(0.2)
	end
	character.HumanoidRootPart.CFrame = tpLocation.CFrame
end

local function onPlayerAdded(player)
	TycoonOwnershipData[player.UserId] = nil
	player.CharacterAdded:Connect(function()
		TycoonOwnershipData.TeleportToTycoon(player)
	end)
end

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

return TycoonOwnershipData
