local PlayerData = {}

local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local playerDataStore = DataStoreService:GetDataStore("PlayerData2.0")
local Leaderboard = require(ServerStorage.Leaderboard)
local UpgradeData = require(ServerStorage.UpgradeData)

PlayerData.MONEY_KEY_NAME = "Money"
PlayerData.LEVEL_KEY_NAME = "Level"
PlayerData.RATE_LEVEL_KEY_NAME = "RateLevel"
PlayerData.OWNED_FTNS_KEY_NAME = "OwnedFountains"
PlayerData.BOOSTS_KEY_NAME = "BoostTime"
PlayerData.SPEED_BOOST_KEY = "Electric"
PlayerData.LUCK_BOOST_KEY = "Luck"

local playerData = {
	--[[
		[userId: string] = {
			["Money"] = money: int
			["Level"] = level: int
			["RateLevel"] = rateLevel: int
			["OwnedFountains"] = ownedFountains: table
			["BoostTime"] = time of last boost: number
		}
	--]]
}

local DEFAULT_PLAYER_DATA = {
	[PlayerData.MONEY_KEY_NAME] = 0,
	[PlayerData.LEVEL_KEY_NAME] = 1,
	[PlayerData.RATE_LEVEL_KEY_NAME] = 1,
	[PlayerData.OWNED_FTNS_KEY_NAME] = {},
	[PlayerData.BOOSTS_KEY_NAME] = {}
}

function copyTable(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

local function updateOverheadGui(player, newLevel)
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:WaitForChild("Head")
	local OverheadLevelGui = head:WaitForChild("OverheadLevelGui")
	OverheadLevelGui.Level.Text = tostring(newLevel)
	OverheadLevelGui.Level.TextColor3 = UpgradeData.GetLevelColor(newLevel)
end

-- Function to load data when a player joins
local function loadPlayerData(player)
	local userId = tostring(player.UserId) -- Convert to string for safety
	local success, data = pcall(function()
		return playerDataStore:GetAsync(userId)
	end)
	
	PlayerData.updatePlayerLevel(player, DEFAULT_PLAYER_DATA[PlayerData.LEVEL_KEY_NAME])
	PlayerData.updatePlayerMoney(player, DEFAULT_PLAYER_DATA[PlayerData.MONEY_KEY_NAME])
	PlayerData.updatePlayerRateLevel(player, DEFAULT_PLAYER_DATA[PlayerData.RATE_LEVEL_KEY_NAME])
	PlayerData.updateValue(player, PlayerData.OWNED_FTNS_KEY_NAME, copyTable(DEFAULT_PLAYER_DATA[PlayerData.OWNED_FTNS_KEY_NAME]))
	PlayerData.updateValue(player, PlayerData.BOOSTS_KEY_NAME, copyTable(DEFAULT_PLAYER_DATA[PlayerData.BOOSTS_KEY_NAME]))

	if success and data then
		if data[PlayerData.MONEY_KEY_NAME] then
			PlayerData.updatePlayerMoney(player, data[PlayerData.MONEY_KEY_NAME])
		end
		if data[PlayerData.LEVEL_KEY_NAME] then
			PlayerData.updatePlayerLevel(player, data[PlayerData.LEVEL_KEY_NAME])
		end
		if data[PlayerData.RATE_LEVEL_KEY_NAME] then
			PlayerData.updatePlayerRateLevel(player, data[PlayerData.RATE_LEVEL_KEY_NAME])
		end
		if data[PlayerData.OWNED_FTNS_KEY_NAME] then
			PlayerData.updateValue(player, PlayerData.OWNED_FTNS_KEY_NAME, data[PlayerData.OWNED_FTNS_KEY_NAME])
		end
	end

	print(player.Name .. "'s data loaded:", data)
end

-- Function to save data when a player leaves
function PlayerData.savePlayerData(player)
	local userId = tostring(player.UserId)
	local userData = PlayerData.getData(player)
	if userData then
		local success, errorMessage = pcall(function()
			playerDataStore:SetAsync(userId, userData)
		end)
		if not success then
			warn("Failed to save data for " .. player.Name .. ": " .. errorMessage)
		else
			print(player.Name .. "'s data saved:", playerData[userId])
		end
	end
end

function PlayerData.getData(player)
	local data = playerData[tostring(player.UserId)] or copyTable(DEFAULT_PLAYER_DATA)
	playerData[tostring(player.UserId)] = data
	return data
end

function PlayerData.getValue(player, key)
	return PlayerData.getData(player)[key]
end

function PlayerData.updateValue(player, key, value)
	local data = PlayerData.getData(player)
	--local oldValue = data[key]
	data[key] = value
	return value
end

function PlayerData.updatePlayerLevel(player, newLevel)	
	PlayerData.updateValue(player, PlayerData.LEVEL_KEY_NAME, newLevel)
	Leaderboard.setStat(player, PlayerData.LEVEL_KEY_NAME, newLevel)
	updateOverheadGui(player, newLevel)
end

function PlayerData.updatePlayerMoney(player, newMoney)
	--calculate new money amt
	
	if newMoney == nil then
		PlayerData.updateValue(player, PlayerData.MONEY_KEY_NAME, nil)
		return
	end
	
	if newMoney < 0 then
		PlayerData.updateValue(player, PlayerData.MONEY_KEY_NAME, 0)
	else
		PlayerData.updateValue(player, PlayerData.MONEY_KEY_NAME, newMoney)
	end

	--update money amt in leaderboard
	Leaderboard.setStat(player, PlayerData.MONEY_KEY_NAME, newMoney)
end

function PlayerData.updatePlayerRateLevel(player, newLevel)
	PlayerData.updateValue(player, PlayerData.RATE_LEVEL_KEY_NAME, newLevel)
end

function PlayerData.addFountainSkin(player, fountainTag)
	table.insert(PlayerData.getValue(player, PlayerData.OWNED_FTNS_KEY_NAME), fountainTag)
end

function PlayerData.updateBoostTime(player, boostKey)
	local data = PlayerData.getValue(player, PlayerData.BOOSTS_KEY_NAME)
	data[boostKey] = os.time()
	PlayerData.updateValue(player, PlayerData.BOOSTS_KEY_NAME, data)
end

function PlayerData.resetPlayer(player)
	PlayerData.updatePlayerLevel(player, DEFAULT_PLAYER_DATA[PlayerData.LEVEL_KEY_NAME])
	PlayerData.updatePlayerRateLevel(player, DEFAULT_PLAYER_DATA[PlayerData.RATE_LEVEL_KEY_NAME])
	PlayerData.updatePlayerMoney(player, DEFAULT_PLAYER_DATA[PlayerData.MONEY_KEY_NAME])
	PlayerData.updateValue(player, DEFAULT_PLAYER_DATA[PlayerData.OWNED_FTNS_KEY_NAME])
	PlayerData.updateValue(player, DEFAULT_PLAYER_DATA[PlayerData.BOOSTS_KEY_NAME])
	PlayerData.savePlayerData(player)
end

local function onPlayerAdded(player)
	loadPlayerData(player)
	--Let DataStorageHandler handle this

	player.CharacterAdded:Connect(function(character)
		-- WaitForChild would stop the player loop, so below should be done in a separate thread
		updateOverheadGui(player, PlayerData.getValue(player, PlayerData.LEVEL_KEY_NAME))
		task.spawn(function()
			-- When a player dies
			character:WaitForChild("Humanoid").Died:Connect(function()
				-- Reset player coins to 0
				--PlayerData.updatePlayerMoney(player, math.max(PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME) - 10, 0))
			end)
		end)
	end)
end

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

local function onPlayerRemoved(player)
	PlayerData.savePlayerData(player)
	PlayerData.updatePlayerLevel(player, nil)
	PlayerData.updatePlayerMoney(player, nil)
	PlayerData.updatePlayerRateLevel(player, nil)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoved)

-- Auto-save data every 5 minutes
game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		PlayerData.savePlayerData(player)
	end
end)


return PlayerData