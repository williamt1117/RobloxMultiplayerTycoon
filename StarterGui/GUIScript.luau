local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local RemoteFunction = ReplicatedStorage:WaitForChild("RequestData")

local UIClickSoundEffect = SoundService:WaitForChild("UIClick")
local LevelUpSoundEffect = SoundService:WaitForChild("LevelUp")

--UI ANIMATION VARIABLES
local tweenTime = 0.2
local growthSize = 1.1
local inStyle = Enum.EasingStyle.Back
local outStyle = Enum.EasingStyle.Quad

local function mouseEnter(uiElement, originalSize)
	local goal = {}
	goal.Size = UDim2.new(originalSize.X.Scale * growthSize, 0, originalSize.Y.Scale * growthSize, 0)
	local tweenInfo = TweenInfo.new(
		tweenTime,
		inStyle,
		Enum.EasingDirection.Out,
		0
	)
	local tween = TweenService:Create(uiElement, tweenInfo, goal)
	tween:Play()
end

local function mouseLeave(uiElement, originalSize)
	local goal = {}
	goal.Size = originalSize
	local tweenInfo = TweenInfo.new(
		tweenTime,
		outStyle,
		Enum.EasingDirection.Out,
		0
	)
	local tween = TweenService:Create(uiElement, tweenInfo, goal)
	tween:Play()
end

local function connectHoverAnimations(uiElement)
	local originalSize = uiElement.Size
	uiElement.MouseEnter:Connect(function(x, y)
		mouseEnter(uiElement, originalSize)
	end)
	uiElement.MouseLeave:Connect(function(x, y)
		mouseLeave(uiElement, originalSize)
	end)
end

local function playUIClickSoundEffect()
	local clone = UIClickSoundEffect:Clone()
	clone.Parent = script.Parent
	clone:Play()
	game:GetService("Debris"):AddItem(clone, clone.TimeLength)
end

--MoneyGUI

local MoneyGUI = script.Parent.MoneyGUI

local MoneyLabel = MoneyGUI.MoneyFrame.MoneyLabel
local PurchaseMoneyButton = MoneyGUI.MoneyFrame.PurchaseMoneyButton

local CurrencyPurchaseFrame = MoneyGUI.CurrencyPurchaseFrame
local CurrencyPurchaseCloseButton = CurrencyPurchaseFrame.CloseButton

local MoneyShopListFrame = CurrencyPurchaseFrame.ScrollingFrame.ListFrame
local Purchase100Button = MoneyShopListFrame.Frame100.TextButton
local Purchase500Button = MoneyShopListFrame.Frame500.TextButton
local Purchase2500Button = MoneyShopListFrame.Frame2500.TextButton
local Purchase10000Button = MoneyShopListFrame.Frame10000.TextButton
local Purchase50000Button = MoneyShopListFrame.Frame50000.TextButton
local Purchase250000Button = MoneyShopListFrame.Frame250000.TextButton
local Purchasex2Button = MoneyShopListFrame.Framex2.TextButton
local Purchasex10Button = MoneyShopListFrame.Framex10.TextButton

local leaderboardMoneyValue = game.Players.LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Money")

local productId100 = 3224615303
local productId500 = 3224614657
local productId2500 = 3224614275
local productId10000 = 3220939216
local productId50000 = 3224615787
local productId250000 = 3224618236
local productIdx2 = 3224619450
local productIdx10 = 3224619871

local function updateCoinsGUI()
	MoneyLabel.Text = "$" .. tostring(leaderboardMoneyValue.Value)
end

leaderboardMoneyValue:GetPropertyChangedSignal("Value"):Connect(updateCoinsGUI)
updateCoinsGUI()

PurchaseMoneyButton.MouseButton1Click:Connect(function()
	--MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, moneyProductId)
	CurrencyPurchaseFrame.Visible = true
	playUIClickSoundEffect()
end)

connectHoverAnimations(PurchaseMoneyButton)

CurrencyPurchaseCloseButton.MouseButton1Click:Connect(function()
	CurrencyPurchaseFrame.Visible = false
	playUIClickSoundEffect()
end)
connectHoverAnimations(CurrencyPurchaseCloseButton)

Purchase100Button.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productId100)
	playUIClickSoundEffect()
end)
connectHoverAnimations(Purchase100Button)

Purchase500Button.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productId500)
	playUIClickSoundEffect()
end)
connectHoverAnimations(Purchase500Button)

Purchase2500Button.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productId2500)
	playUIClickSoundEffect()
end)
connectHoverAnimations(Purchase2500Button)

Purchase10000Button.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productId10000)
	playUIClickSoundEffect()
end)
connectHoverAnimations(Purchase10000Button)

Purchase50000Button.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productId50000)
	playUIClickSoundEffect()
end)
connectHoverAnimations(Purchase50000Button)

Purchase250000Button.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productId250000)
	playUIClickSoundEffect()
end)
connectHoverAnimations(Purchase250000Button)

Purchasex2Button.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productIdx2)
	playUIClickSoundEffect()
end)
connectHoverAnimations(Purchasex2Button)

Purchasex10Button.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productIdx10)
	playUIClickSoundEffect()
end)
connectHoverAnimations(Purchasex10Button)

--End MoneyGUI

--LevelGUI

local LevelGUI = script.Parent.LevelGUI

local LevelLabel = LevelGUI.LevelFrame.LevelLabel

local leaderboardLevelValue = game.Players.LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Level")

local function updateLevelGUI()
	LevelLabel.Text = "Level " .. tostring(leaderboardLevelValue.Value)
end


leaderboardLevelValue:GetPropertyChangedSignal("Value"):Connect(updateLevelGUI)
updateLevelGUI()

--End LevelGUI

--UpgradeGUI

local UpgradeGUI = script.Parent.UpgradeGUI

local UpgradeOpenButton = UpgradeGUI.OpenButton
local UpgradeFrame = UpgradeGUI.UpgradeFrame
local UpgradeCloseButton = UpgradeFrame.CloseButton
local FountainCosmeticButton = UpgradeFrame.ListFrame.FountainCosmeticMenuButton
local LevelUpButton = UpgradeFrame.ListFrame.LevelUpButton
local RateUpgradeButton = UpgradeFrame.ListFrame.RateUpgradeButton
local AnalyticsFrame = UpgradeFrame.AnalyticsFrame
local RateLabel = AnalyticsFrame.RateLabel
local CooldownLabel = AnalyticsFrame.CooldownLabel
local CopperDistributionLabel = AnalyticsFrame.DistributionFrame.CopperFrame.TextLabel
local SilverDistributionLabel = AnalyticsFrame.DistributionFrame.SilverFrame.TextLabel
local GoldDistributionLabel = AnalyticsFrame.DistributionFrame.GoldFrame.TextLabel
local DiamondDistributionLabel = AnalyticsFrame.DistributionFrame.DiamondFrame.TextLabel
local AmethystDistributionLabel = AnalyticsFrame.DistributionFrame.AmethystFrame.TextLabel
local RubyDistributionLabel = AnalyticsFrame.DistributionFrame.RubyFrame.TextLabel

local function refreshDisplayedCosts()
	LevelUpButton.Text = "Level Up ($" .. tostring(RemoteFunction:InvokeServer("GetLevelMoneyRequirement")) .. ")"
	RateUpgradeButton.Text = "Speed Up ($" .. tostring(RemoteFunction:InvokeServer("GetRateMoneyRequirement")) .. ")"
end

local function refreshAnalytics()
	local data = RemoteFunction:InvokeServer("RequestPercentages")

	local copperPercent = data[1]
	local silverPercent = data[2]
	local goldPercent = data[3]
	local diamondPercent = data[4]
	local amethystPercent = data[5]
	local rubyPercent = data[6]

	CopperDistributionLabel.Text = tostring(math.round(copperPercent*10000)/100) .. "%"
	SilverDistributionLabel.Text = tostring(math.round(silverPercent*10000)/100) .. "%"
	GoldDistributionLabel.Text = tostring(math.round(goldPercent*10000)/100) .. "%"
	DiamondDistributionLabel.Text = tostring(math.round(diamondPercent*10000)/100) .. "%"
	AmethystDistributionLabel.Text = tostring(math.round(amethystPercent*10000)/100) .. "%"
	RubyDistributionLabel.Text = tostring(math.round(rubyPercent*10000)/100) .. "%"

	local rateLevel = RemoteFunction:InvokeServer("GetRateLevel")
	local genRateDelay = RemoteFunction:InvokeServer("RequestGenDelay")
	local averageValuableWorth = 1*copperPercent + 10*silverPercent + 25*goldPercent + 100*diamondPercent + 250*amethystPercent + 1000*rubyPercent

	RateLabel.Text = "Rate: $" .. tostring(math.round((averageValuableWorth/genRateDelay)*100)/100) .. "/s"
	CooldownLabel.Text = "Cooldown: " .. tostring(math.round(genRateDelay*1000)/1000) .. "s"

end

UpgradeOpenButton.MouseButton1Click:Connect(function()
	UpgradeFrame.Visible = true
	UpgradeOpenButton.Visible = false
	playUIClickSoundEffect()
end)

UpgradeCloseButton.MouseButton1Click:Connect(function()
	UpgradeFrame.Visible = false
	UpgradeOpenButton.Visible = true
	playUIClickSoundEffect()
end)

connectHoverAnimations(UpgradeOpenButton)

local lastLevelUpTime = time()
local octaveShift = 1
local OCTAVE_INCREMENT = 0.05
local CHAINING_TIME = 2
local MAX_OCTAVE_SHIFT = 1.5

local function playLevelUpSoundEffect()
	local curTime = time()
	if curTime - lastLevelUpTime < CHAINING_TIME then
		octaveShift = math.min(octaveShift + OCTAVE_INCREMENT, MAX_OCTAVE_SHIFT)
	else
		octaveShift = 1
	end
	lastLevelUpTime = curTime
	
	local sound = LevelUpSoundEffect:Clone()
	sound.Parent = script
	sound.PitchShiftSoundEffect.Octave = octaveShift
	sound:Play()
	task.wait(1)
	sound:Destroy()
end


local function attemptLevelUp()
	local success = RemoteFunction:InvokeServer("LevelUp")

	if success then
		refreshDisplayedCosts()
		refreshAnalytics()
		playLevelUpSoundEffect()
	end
end

local function attemptRateUp()
	local success = RemoteFunction:InvokeServer("RateUp")
	
	if success then
		refreshDisplayedCosts()
		refreshAnalytics()
		playLevelUpSoundEffect()
	end
end

LevelUpButton.MouseButton1Click:Connect(function()
	local tycoon = RemoteFunction:InvokeServer("GetTycoon")

	if tycoon == nil then
		return
	end

	attemptLevelUp()
end)
connectHoverAnimations(LevelUpButton)

RateUpgradeButton.MouseButton1Click:Connect(function()
	local tycoon = RemoteFunction:InvokeServer("GetTycoon")

	if tycoon == nil then
		return
	end
	
	attemptRateUp()
end)
connectHoverAnimations(RateUpgradeButton)

refreshDisplayedCosts()
refreshAnalytics()

--End UpgradeGUI

--FountainSkinsGUI

local FountainSkinsOpenButton = UpgradeFrame.ListFrame.FountainCosmeticMenuButton

local FountainSkinsGUI = script.Parent.FountainSkinsGUI

local FountainSkinsFrame = FountainSkinsGUI.FountainSkinsFrame
local FountainSkinsCloseButton = FountainSkinsFrame.CloseButton
local ShopFrame = FountainSkinsFrame.ScrollingFrame.ListFrame
local BabyFountainButton = ShopFrame.BabyFountainFrame.TextButton
local DarkFountainButton = ShopFrame.DarkFountainFrame.TextButton
local DrinkingFountainButton = ShopFrame.DrinkingFountainFrame.TextButton
local GoldFountainButton = ShopFrame.GoldFountainFrame.TextButton
local HelloKittyFountainButton = ShopFrame.HelloKittyFountainFrame.TextButton
local LightFountainButton = ShopFrame.LightFountainFrame.TextButton
local LucasFountainButton = ShopFrame.LucasFountainFrame.TextButton
local MyFountainButton = ShopFrame.MyFountainFrame.TextButton

local lastEquipped = BabyFountainButton

FountainSkinsOpenButton.MouseButton1Click:Connect(function()
	playUIClickSoundEffect()
	FountainSkinsFrame.Visible = true
end)
connectHoverAnimations(FountainSkinsOpenButton)

FountainSkinsCloseButton.MouseButton1Click:Connect(function()
	playUIClickSoundEffect()
	FountainSkinsFrame.Visible = false
end)
connectHoverAnimations(FountainSkinsCloseButton)

local equippedColor = Color3.fromRGB(43, 145, 242)
local normalColor = Color3.fromRGB(98, 209, 255)

BabyFountainButton.MouseButton1Click:Connect(function()
	playUIClickSoundEffect()
	local fountainTag = "BabyFountain"
	RemoteFunction:InvokeServer("loadFountainSkin", fountainTag)
	lastEquipped.Text = "Owned"
	BabyFountainButton.Text = "Equipped"
	lastEquipped.BackgroundColor3 = normalColor
	BabyFountainButton.BackgroundColor3 = equippedColor
	lastEquipped = BabyFountainButton
end)
connectHoverAnimations(BabyFountainButton)

local function fountainButtonClicked(fountainTag, button)
	playUIClickSoundEffect()
	
	if not RemoteFunction:InvokeServer("PlayerTycoonOwned") then
		return
	end
	
	local owned = RemoteFunction:InvokeServer("isFountainOwned", fountainTag)

	if owned then
		--equip fountain
		RemoteFunction:InvokeServer("loadFountainSkin", fountainTag)
		
		lastEquipped.Text = "Owned"
		button.Text = "Equipped"
		lastEquipped.BackgroundColor3 = normalColor
		button.BackgroundColor3 = equippedColor
		lastEquipped = button
		
	else
		--attempt purchase
		local success = RemoteFunction:InvokeServer("attemptFountainPurchase", fountainTag)
		if success then
			RemoteFunction:InvokeServer("loadFountainSkin", fountainTag)
			lastEquipped.Text = "Owned"
			button.Text = "Equipped"
			lastEquipped.BackgroundColor3 = normalColor
			button.BackgroundColor3 = equippedColor
			lastEquipped = button
		end
	end
end

MyFountainButton.MouseButton1Click:Connect(function()
	local fountainTag = "MyFountain"
	fountainButtonClicked(fountainTag, MyFountainButton)
end)
connectHoverAnimations(MyFountainButton)

LightFountainButton.MouseButton1Click:Connect(function()
	local fountainTag = "LightFountain"
	fountainButtonClicked(fountainTag, LightFountainButton)
end)
connectHoverAnimations(LightFountainButton)

DarkFountainButton.MouseButton1Click:Connect(function()
	local fountainTag = "DarkFountain"
	fountainButtonClicked(fountainTag, DarkFountainButton)
end)
connectHoverAnimations(DarkFountainButton)

DrinkingFountainButton.MouseButton1Click:Connect(function()
	local fountainTag = "DrinkingFountain"
	fountainButtonClicked(fountainTag, DrinkingFountainButton)
end)
connectHoverAnimations(DrinkingFountainButton)

GoldFountainButton.MouseButton1Click:Connect(function()
	local fountainTag = "GoldFountain"
	fountainButtonClicked(fountainTag, GoldFountainButton)
end)
connectHoverAnimations(GoldFountainButton)

HelloKittyFountainButton.MouseButton1Click:Connect(function()
	local fountainTag = "HelloKittyFountain"
	fountainButtonClicked(fountainTag, HelloKittyFountainButton)
end)
connectHoverAnimations(HelloKittyFountainButton)

LucasFountainButton.MouseButton1Click:Connect(function()
	local fountainTag = "LucasFountain"
	fountainButtonClicked(fountainTag, LucasFountainButton)
end)
connectHoverAnimations(LucasFountainButton)

local lucasFountainId = 1076626210
local helloKittyFountainId = 1076995642
local goldFountainId = 1077019638
local drinkingFountainId = 1076830135
local darkFountainId = 1077622333

local function initializeFountainShopText()
	BabyFountainButton.Text = "Equipped"
	
	MyFountainButton.Text = "$1000"
	LightFountainButton.Text = "$10000"
	DarkFountainButton.Text = "300R"
	DrinkingFountainButton.Text = "300R"
	GoldFountainButton.Text = "300R"
	HelloKittyFountainButton.Text = "300R"
	LucasFountainButton.Text = "300R"
	
	if RemoteFunction:InvokeServer("isFountainOwned", "MyFountain") then
		MyFountainButton.Text = "Owned"
	end
	if RemoteFunction:InvokeServer("isFountainOwned", "LightFountain") then
		LightFountainButton.Text = "Owned"
	end
	if RemoteFunction:InvokeServer("isFountainOwned", "DarkFountain") then
		DarkFountainButton.Text = "Owned"
	end
	if RemoteFunction:InvokeServer("isFountainOwned", "DrinkingFountain") then
		DrinkingFountainButton.Text = "Owned"
	end
	if RemoteFunction:InvokeServer("isFountainOwned", "GoldFountain") then
		GoldFountainButton.Text = "Owned"
	end
	if RemoteFunction:InvokeServer("isFountainOwned", "HelloKittyFountain") then
		HelloKittyFountainButton.Text = "Owned"
	end
	if RemoteFunction:InvokeServer("isFountainOwned", "LucasFountain") then
		LucasFountainButton.Text = "Owned"
	end
end

initializeFountainShopText()

--End FountainSkinsGUI

--MenuGUI

local MenuGUI = script.Parent.MenuGUI

local ResetTycoonButton = MenuGUI.ResetTycoonButton

local ResetConfirmationFrame = MenuGUI.ResetConfirmationFrame
local NoResetConfirmationButton = ResetConfirmationFrame.NoButton
local YesResetConfirmationButton = ResetConfirmationFrame.YesButton

local musicMuted = false
local sfxMuted = false

ResetTycoonButton.MouseButton1Click:Connect(function()
	ResetConfirmationFrame.Visible = true
	playUIClickSoundEffect()
end)
connectHoverAnimations(ResetTycoonButton)

NoResetConfirmationButton.MouseButton1Click:Connect(function()
	ResetConfirmationFrame.Visible = false
	playUIClickSoundEffect()
end)
connectHoverAnimations(NoResetConfirmationButton)

YesResetConfirmationButton.MouseButton1Click:Connect(function()
	playUIClickSoundEffect()
	local success = RemoteFunction:InvokeServer("ResetTycoon")
	refreshDisplayedCosts()
	updateCoinsGUI()
	updateLevelGUI()
	initializeFountainShopText()
	refreshAnalytics()
	ResetConfirmationFrame.Visible = false
end)
connectHoverAnimations(YesResetConfirmationButton)

--End MenuGUI

--Start TeleportGUI

local TeleportGUI = script.Parent.TeleportGUI

local TeleportButton = TeleportGUI.TeleportButton

TeleportButton.MouseButton1Click:Connect(function()
	RemoteFunction:InvokeServer("TeleportToTycoon")
	playUIClickSoundEffect()
end)

connectHoverAnimations(TeleportButton)

--End TeleportGUI

--Start EventGUI

local EventGUI = script.Parent.EventGUI

local ProgressBar = EventGUI.EventFrame.ProgressBarContainer.ProgressBar
local EventInfoLabel = EventGUI.EventFrame.EventInfoLabel

local waitTimeValue = workspace.World.CentralEventStructure.CentralEventScript.WaitTime

waitTimeValue:GetPropertyChangedSignal("Value"):Connect(function()
	local waitTime = waitTimeValue.Value
	local progressedTime = 300 - waitTime
	ProgressBar.Size = UDim2.new(math.clamp(progressedTime / 300, 0.05, 1), 0, 1, 0)
	
	if waitTime ~= 0 then
		EventInfoLabel.Text = tostring(waitTime) .. "s Until Next COIN RAIN Event!"
	else
		EventInfoLabel.Text = "COIN RAIN Event Active Now!"
	end
	
	
end)

--End EventGUI

--Start BoostGUI

local BoostGUI = script.Parent.BoostGUI
local RateBoostLabel = BoostGUI.Frame.RateBoost
local LuckBoostLabel = BoostGUI.Frame.LuckBoost

local function updateRateBoostLabel()
	local boostTimes = RemoteFunction:InvokeServer("GetBoostTimes")
	local lastSpeedBoost = boostTimes["Electric"]
	local serverTime = RemoteFunction:InvokeServer("GetServerTime")
	
	if not lastSpeedBoost then
		RateBoostLabel.Visible = false
		return
	end
	
	if os.time() - lastSpeedBoost > 15 then
		RateBoostLabel.Visible = false
	else
		RateBoostLabel.Visible = true
		RateBoostLabel.Text = "Speed Boost: " .. tostring(math.round(15 - (serverTime - lastSpeedBoost))) .. "s"
	end
end

local function updateLuckBoostLabel()
	local boostTimes = RemoteFunction:InvokeServer("GetBoostTimes")
	local lastLuckBoost = boostTimes["Luck"]
	local serverTime = RemoteFunction:InvokeServer("GetServerTime")
	
	if not lastLuckBoost then
		LuckBoostLabel.Visible = false
		return
	end
	
	if os.time() - lastLuckBoost > 15 then
		LuckBoostLabel.Visible = false
	else
		LuckBoostLabel.Visible = true
		LuckBoostLabel.Text = "Luck Boost: " .. tostring(math.round(15 - (serverTime - lastLuckBoost))) .. "s"
	end
end

--End BoostGUI

--Start DonateGUI

local DonateGUI = script.Parent.DonateGUI
local DonateButton = DonateGUI.DonateButton

local productIdDonate = 3226953113

DonateButton.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productIdDonate)
	playUIClickSoundEffect()
end)
connectHoverAnimations(DonateButton)

--End DonateGUI

while true do
	updateRateBoostLabel()
	updateLuckBoostLabel()
	task.wait(0.5)
end