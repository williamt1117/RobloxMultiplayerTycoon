local LevelingData = {}

local ServerStorage = game:GetService("ServerStorage")

local PlayerData = require(ServerStorage:WaitForChild("PlayerData"))

local SIGFIGS = 3

function LevelingData.LevelMoneyNeeded(lvl)
	local unrounded = 10 + 4*(lvl-1)^(1.35)
	local sigfig
	local magnitude = 10 ^ math.floor(math.log10(math.abs(unrounded)) + 1 - SIGFIGS)
	return math.round(math.round(unrounded / magnitude) * magnitude)
end

function LevelingData.RateMoneyNeeded(lvl)
	return 50*(lvl-1)^2
end

function LevelingData.LevelUp(player)
	local playerLevel = PlayerData.getValue(player, PlayerData.LEVEL_KEY_NAME)
	local playerMoney = PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)
	local moneyRequired = LevelingData.LevelMoneyNeeded(playerLevel+1)
	
	if playerMoney >= moneyRequired then
		-- level up
		
		local oldLevel = PlayerData.getValue(player, PlayerData.LEVEL_KEY_NAME)
		if oldLevel == nil then
			oldLevel = 1
		end
		
		PlayerData.updatePlayerLevel(player, oldLevel + 1)
		PlayerData.updatePlayerMoney(player, playerMoney - moneyRequired)
		return true
	else
		return false
	end
end

function LevelingData.RateUp(player)
	local playerRateLevel = PlayerData.getValue(player, PlayerData.RATE_LEVEL_KEY_NAME)
	local playerMoney = PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)
	local moneyRequired = LevelingData.RateMoneyNeeded(playerRateLevel + 1)

	if playerMoney >= moneyRequired then
		-- level up

		local oldRateLevel = PlayerData.getValue(player, PlayerData.RATE_LEVEL_KEY_NAME)
		if oldRateLevel == nil then
			oldRateLevel = 1
		end

		PlayerData.updatePlayerRateLevel(player, oldRateLevel + 1)
		PlayerData.updatePlayerMoney(player, playerMoney - moneyRequired)
		return true
	else
		return false
	end
end

return LevelingData