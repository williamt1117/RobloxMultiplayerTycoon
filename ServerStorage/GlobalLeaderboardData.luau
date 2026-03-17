local GlobalLeaderboardData = {}

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local earningsLeaderboardStore = DataStoreService:GetOrderedDataStore("EarningsLeaderboard")
local PlayerData = require(ServerStorage.PlayerData)
local LevelingData = require(ServerStorage.LevelingData)

function GlobalLeaderboardData.UpdatePlayerEarnings(player)
	local earnings = PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)
	local level = PlayerData.getValue(player, PlayerData.LEVEL_KEY_NAME)
	local rateLevel = PlayerData.getValue(player, PlayerData.RATE_LEVEL_KEY_NAME)
	
	if level > 1 then
		for i = 2, level do
			earnings = earnings + LevelingData.LevelMoneyNeeded(i)
		end
	end
	
	if rateLevel > 1 then
		for i = 2, rateLevel do
			earnings = earnings + LevelingData.RateMoneyNeeded(i)
		end
	end
	
	earningsLeaderboardStore:SetAsync(player.Name, earnings)
end

function GlobalLeaderboardData.GetTopTenPlayers()
	local pages = earningsLeaderboardStore:GetSortedAsync(false, 10)
	local topTen = pages:GetCurrentPage()
	return topTen
end

function GlobalLeaderboardData.UpdateAllActivePlayers()
	for _, player in Players:GetPlayers() do
		local money = PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)
		GlobalLeaderboardData.UpdatePlayerEarnings(player)
	end
end

return GlobalLeaderboardData
