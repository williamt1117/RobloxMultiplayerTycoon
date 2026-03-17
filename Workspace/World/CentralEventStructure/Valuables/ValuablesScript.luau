local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local PlayerData = require(ServerStorage.PlayerData)
local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)
local UpgradeData = require(ServerStorage.UpgradeData)

local tycoon = script.Parent.Parent
local coinPickupSound = SoundService.CoinPickup

local function getPlayerGenerationRate(player)
	local percentages = UpgradeData.CalculateValuablePercentages(PlayerData.getValue(player, PlayerData.LEVEL_KEY_NAME))
	local averageValuableWorth = 1*percentages[UpgradeData.COPPER_KEY] + 
		10*percentages[UpgradeData.SILVER_KEY] + 
		25*percentages[UpgradeData.GOLD_KEY] + 
		100*percentages[UpgradeData.DIAMOND_KEY] + 
		250*percentages[UpgradeData.AMETHYST_KEY] + 
		1000*percentages[UpgradeData.RUBY_KEY]
	
	local rate = UpgradeData.CalculateGenerationDelay(PlayerData.getValue(player, PlayerData.RATE_LEVEL_KEY_NAME))
	return averageValuableWorth / rate
end

local function attachVisualDespawn(part)
	task.wait(10)
	
	local goal = {}
	goal.Transparency = 1
	local tweenInfo = TweenInfo.new(
		5,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		0,
		false
	)

	local tween = TweenService:Create(part, tweenInfo, goal)
	tween:Play()
	tween.Completed:Wait()
	
	if part then
		part:Destroy()
	end
end

local function onTouch(otherPart, valuable)
	local character = otherPart.parent
	local player = Players:GetPlayerFromCharacter(character)

	if not player then
		return
	end
	
	
	local playerGenRate = getPlayerGenerationRate(player)
	local multiplier = valuable:WaitForChild("Multiplier").Value
	local coinWorth = math.round(playerGenRate * multiplier)
	
	local oldMoney = PlayerData.getValue(player, PlayerData.MONEY_KEY_NAME)
	if oldMoney == nil then
		oldMoney = 0
	end

	local newSound = coinPickupSound:Clone()
	newSound.Parent = valuable
	newSound.PlayOnRemove = true

	PlayerData.updatePlayerMoney(player, oldMoney + coinWorth)
	valuable:Destroy()
end

-- Handle existing parts first
for _, part in ipairs(script.Parent:GetChildren()) do
	if not part:IsA("Script") then
		part.Touched:Connect(function(otherPart)
			onTouch(otherPart, part)
		end)
	end
end

-- Handle new parts added to the parent
script.Parent.ChildAdded:Connect(function(child)
	if not child:IsA("Script") then
		child.Touched:Connect(function(otherPart)
			onTouch(otherPart, child)
		end)
		
		attachVisualDespawn(child)
	end	
end)