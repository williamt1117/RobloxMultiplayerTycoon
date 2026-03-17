local FountainSkinData = {}

local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local MarketplaceService = game:GetService("MarketplaceService")

local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)
local PlayerData = require(ServerStorage.PlayerData)

FountainSkinData.BABY_FTN_TAG = "BabyFountain"
FountainSkinData.LUCAS_FTN_TAG = "LucasFountain"
FountainSkinData.LIGHT_FTN_TAG = "LightFountain"
FountainSkinData.DARK_FTN_TAG = "DarkFountain"
FountainSkinData.GOLD_FTN_TAG = "GoldFountain"
FountainSkinData.MY_FTN_TAG = "MyFountain"
FountainSkinData.DRINKING_FTN_TAG = "DrinkingFountain"
FountainSkinData.HELLO_KITTY_FTN_TAG = "HelloKittyFountain"

local fountainSkinData = {}

local DEFAULT_DATA = {
	[FountainSkinData.BABY_FTN_TAG] = nil,
	[FountainSkinData.LUCAS_FTN_TAG] = nil,
	[FountainSkinData.LIGHT_FTN_TAG] = nil,
	[FountainSkinData.DARK_FTN_TAG] = nil,
	[FountainSkinData.GOLD_FTN_TAG] = nil,
	[FountainSkinData.MY_FTN_TAG] = nil,
	[FountainSkinData.DRINKING_FTN_TAG] = nil,
	[FountainSkinData.HELLO_KITTY_FTN_TAG] = nil
}

function copyTable(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

function FountainSkinData.InitializeTycoonSkins(tycoon)
	local moneyFountain = tycoon.MoneyFountain
	
	fountainSkinData[tycoon] = copyTable(DEFAULT_DATA)

	for _, child in pairs(moneyFountain:GetChildren()) do
		if CollectionService:HasTag(child, FountainSkinData.BABY_FTN_TAG) then
			fountainSkinData[tycoon][FountainSkinData.BABY_FTN_TAG] = child
		elseif child.Name == "MoneyFountainModel" then
			for _, tag in ipairs(CollectionService:GetTags(child)) do
				fountainSkinData[tycoon][tag] = child
				child.Hitbox.CustomPhysicalProperties = PhysicalProperties.new(1, 0, 1, 100, 1)
				child.Parent = nil
			end
		end
	end
end

function FountainSkinData.loadFountainSkin(tycoon, fountainTag)
	if not tycoon then
		return
	end
	
	local moneyFountain = tycoon.MoneyFountain
	local curModel = moneyFountain.MoneyFountainModel
	
	curModel.Parent = nil
	(fountainSkinData[tycoon][fountainTag]).Parent = moneyFountain
end

local tagToPassId = {
	[FountainSkinData.LUCAS_FTN_TAG] = 1076626210,
	[FountainSkinData.HELLO_KITTY_FTN_TAG] = 1076995642,
	[FountainSkinData.GOLD_FTN_TAG] = 1077019638,
	[FountainSkinData.DRINKING_FTN_TAG] = 1076830135,
	[FountainSkinData.DARK_FTN_TAG] = 1077622333
}

function FountainSkinData.isFountainOwned(player, fountainTag)
	local passId = tagToPassId[fountainTag]
	
	if passId then
		local hasPass
		local success, message = pcall(function()
			hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, passId)
		end)
		return hasPass
	else
		for _, val in ipairs(PlayerData.getValue(player, PlayerData.OWNED_FTNS_KEY_NAME)) do
			if val == fountainTag then
				return true
			end
		end
		return false
	end
end

local tagToCost = {
	[FountainSkinData.MY_FTN_TAG] = 1000,
	[FountainSkinData.LIGHT_FTN_TAG] = 10000
}

function FountainSkinData.attemptFountainPurchase(player, fountainTag)
	local passId = tagToPassId[fountainTag]
	
	if passId then
		MarketplaceService:PromptGamePassPurchase(player, passId)
		return false
	else
		local cost = tagToCost[fountainTag]
		local playerMoney = PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)
		
		if playerMoney >= cost then
			local newMoney = playerMoney - cost
			PlayerData.updatePlayerMoney(player, newMoney)
			PlayerData.addFountainSkin(player, fountainTag)
			return true
		end
		
		return false
	end
end

return FountainSkinData