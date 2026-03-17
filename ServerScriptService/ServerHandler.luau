local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local TycoonOwnershipData = require(ServerStorage:WaitForChild("TycoonOwnershipData"))
local PlayerData = require(ServerStorage:WaitForChild("PlayerData"))
local LevelingData = require(ServerStorage:WaitForChild("LevelingData"))
local UpgradeData = require(ServerStorage:WaitForChild("UpgradeData"))
local FountainSkinData = require(ServerStorage:WaitForChild("FountainSkinData"))

local RemoteFunction = ReplicatedStorage:WaitForChild("RequestData")

local function handleRequest(player, action, ...)
	if action == "GetTycoon" then
		return TycoonOwnershipData.GetTycoon(player)
		
	elseif action == "GetMoney" then
		return PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)
	elseif action == "GetLevel" then
		return PlayerData.getValue(player, PlayerData.LEVEL_KEY_NAME)
	elseif action == "GetRateLevel" then
		return PlayerData.getValue(player, PlayerData.RATE_LEVEL_KEY_NAME)
	elseif action == "GetLevelMoneyRequirement" then
		local curLevel = PlayerData.getValue(player, PlayerData.LEVEL_KEY_NAME)
		return LevelingData.LevelMoneyNeeded(curLevel+1)
	elseif action == "GetRateMoneyRequirement" then
		local curLevel = PlayerData.getValue(player, PlayerData.RATE_LEVEL_KEY_NAME)
		local moneyNeeded = LevelingData.RateMoneyNeeded(curLevel+1)
		return moneyNeeded
	elseif action == "LevelUp" then
		return LevelingData.LevelUp(player)
	elseif action == "RateUp" then
		return LevelingData.RateUp(player)
	elseif action == "ResetTycoon" then
		PlayerData.resetPlayer(player)
		
		local tycoon = TycoonOwnershipData.GetTycoon(player)
		if not tycoon then
			return true
		end
		local valuablesFolder = tycoon.Valuables
		for _, v in ipairs(valuablesFolder:GetChildren()) do
			if v.className == "Part" or v.className == "MeshPart" then
				v:Destroy()
			end
		end
		
		
		
		FountainSkinData.loadFountainSkin(tycoon, FountainSkinData.BABY_FTN_TAG)
		
		return true
	elseif action == "RequestPercentages" then
		local data = UpgradeData.CalculateValuablePercentages(PlayerData.getValue(player, PlayerData.LEVEL_KEY_NAME))
		return {
			data[UpgradeData.COPPER_KEY] or 0,
			data[UpgradeData.SILVER_KEY] or 0,
			data[UpgradeData.GOLD_KEY] or 0,
			data[UpgradeData.DIAMOND_KEY] or 0,
			data[UpgradeData.AMETHYST_KEY] or 0,
			data[UpgradeData.RUBY_KEY] or 0
		}
	elseif action == "RequestGenDelay" then
		return UpgradeData.CalculateGenerationDelay(PlayerData.getValue(player, PlayerData.RATE_LEVEL_KEY_NAME))
	elseif action == "isFountainOwned" then
		local fountainTag = ...
		return FountainSkinData.isFountainOwned(player, fountainTag)
	elseif action == "loadFountainSkin" then
		local fountainTag = ...
		FountainSkinData.loadFountainSkin(TycoonOwnershipData.GetTycoon(player), fountainTag)
	elseif action == "attemptFountainPurchase" then
		local fountainTag = ...
		return FountainSkinData.attemptFountainPurchase(player, fountainTag)
	elseif action == "PlayerTycoonOwned" then
		return TycoonOwnershipData.GetTycoon(player) ~= nil
	elseif action == "TeleportToTycoon" then
		TycoonOwnershipData.TeleportToTycoon(player)
	elseif action == "GetBoostTimes" then
		return PlayerData.getValue(player, PlayerData.BOOSTS_KEY_NAME)
	elseif action == "GetServerTime" then
		return os.time()
	end
end

RemoteFunction.OnServerInvoke = handleRequest