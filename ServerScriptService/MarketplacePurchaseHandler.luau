local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local PlayerData = require(ServerStorage.PlayerData)
local FountainSkinData = require(ServerStorage.FountainSkinData)
local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)

local productId100 = 3224615303
local productId500 = 3224614657
local productId2500 = 3224614275
local productId10000 = 3220939216
local productId50000 = 3224615787
local productId250000 = 3224618236
local productIdx2 = 3224619450
local productIdx10 = 3224619871

local lucasFountainId = 1076626210
local helloKittyFountainId = 1076995642
local goldFountainId = 1077019638
local drinkingFountainId = 1076830135
local darkFountainId = 1077622333

local function processCoinPurchase(player, coinAmt)
	local oldMoney = PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)
	if not oldMoney then
		oldMoney = 0
	end

	PlayerData.updatePlayerMoney(player, oldMoney+coinAmt)

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

local function processMultiplierPurchase(player, mult)
	local oldMoney = PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)
	if not oldMoney then
		oldMoney = 0
	end

	PlayerData.updatePlayerMoney(player, oldMoney*mult)

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

local function processReceipt(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	if receiptInfo.ProductId == productId100 then
		return processCoinPurchase(player, 100)
	elseif receiptInfo.ProductId == productId500 then
		return processCoinPurchase(player, 500)
	elseif receiptInfo.ProductId == productId2500 then
		return processCoinPurchase(player, 2500)
	elseif receiptInfo.ProductId == productId10000 then
		return processCoinPurchase(player, 10000)
	elseif receiptInfo.ProductId == productId50000 then
		return processCoinPurchase(player, 50000)
	elseif receiptInfo.ProductId == productId250000 then
		return processCoinPurchase(player, 250000)
	elseif receiptInfo.ProductId == productIdx2 then
		return processMultiplierPurchase(player, 2)
	elseif receiptInfo.ProductId == productIdx10 then
		return processMultiplierPurchase(player, 10)
	end

	-- If it's an unknown product, do nothing:
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

local function gamePassPurchaseFinished(...)
	local player, id, purchased = ...
	
	print(player, id, purchased)
	
	if not purchased then
		return
	end
	
	local tycoon = TycoonOwnershipData.GetTycoon(player)
	
	if id == lucasFountainId then
		FountainSkinData.loadFountainSkin(tycoon, FountainSkinData.LUCAS_FTN_TAG)
	elseif id == helloKittyFountainId then
		FountainSkinData.loadFountainSkin(tycoon, FountainSkinData.HELLO_KITTY_FTN_TAG)
	elseif id == goldFountainId then
		FountainSkinData.loadFountainSkin(tycoon, FountainSkinData.GOLD_FTN_TAG)
	elseif id == drinkingFountainId then
		FountainSkinData.loadFountainSkin(tycoon, FountainSkinData.DRINKING_FTN_TAG)
	elseif id == darkFountainId then
		FountainSkinData.loadFountainSkin(tycoon, FountainSkinData.DARK_FTN_TAG)
	end	
end

MarketplaceService.ProcessReceipt = processReceipt
MarketplaceService.PromptGamePassPurchaseFinished:Connect(gamePassPurchaseFinished)