local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")
local CollectionService = game:GetService("CollectionService")

local PlayerData = require(ServerStorage.PlayerData)
local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)

local coinPickupSound = SoundService.CoinPickup
local boostPickupSound = SoundService.BoostPickup

local tycoonFolder = script.Parent

for _, tycoonPlot in pairs(tycoonFolder:GetChildren()) do
	if not tycoonPlot:IsA("Folder") then
		continue
	end
	
	local tycoon = tycoonPlot.Tycoon
	
	
	local function onTouch(otherPart, valuable)
		local character = otherPart.parent
		local player = Players:GetPlayerFromCharacter(character)


		if not player then
			if otherPart.Name == "Carpet" then
				player = TycoonOwnershipData.GetPlayerFromTycoon(tycoon)
			end
		end

		if not player then
			return
		end

		if TycoonOwnershipData.GetTycoon(player) ~= tycoon then
			return
		end

		if otherPart.Name == "Carpet" then
			task.wait(0.15) --visual clarity
		end

		if CollectionService:HasTag(valuable, "currency") then
			local worthChild = valuable:WaitForChild("Worth", 0.1)
			if not worthChild then
				warn("Couldn't find worth. Already Destroyed?")
				return
			end

			local oldMoney = PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)

			if oldMoney == nil then
				oldMoney = 0
			end

			PlayerData.updatePlayerMoney(player, oldMoney + worthChild.Value)
			
			local newSound = coinPickupSound:Clone()
			newSound.Parent = valuable
			newSound.PlayOnRemove = true
			valuable:Destroy()
		elseif CollectionService:HasTag(valuable, "speedBoost") then
			PlayerData.updateBoostTime(player, PlayerData.SPEED_BOOST_KEY)
			
			local newSound = boostPickupSound:Clone()
			newSound.Parent = valuable
			newSound.PlayOnRemove = true
			valuable:Destroy()
		elseif CollectionService:HasTag(valuable, "luckBoost") then
			PlayerData.updateBoostTime(player, PlayerData.LUCK_BOOST_KEY)
			local newSound = boostPickupSound:Clone()
			newSound.Parent = valuable
			newSound.PlayOnRemove = true
			valuable:Destroy()
		else
			error("valuable tag unidentified")
		end

		
	end
	
	local valuablesFolder = tycoon.Valuables

	-- Handle existing parts first
	for _, part in ipairs(valuablesFolder:GetChildren()) do
		if part:IsA("BasePart") then
			part.Touched:Connect(function(otherPart)
				onTouch(otherPart, part)
			end)
		end
	end

	-- Handle new parts added to the parent
	valuablesFolder.ChildAdded:Connect(function(child)
		if child:IsA("BasePart") then
			task.wait(0.5)
			child.Touched:Connect(function(otherPart)
				onTouch(otherPart, child)
			end)
		end	
	end)
	
end