local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)
local PlayerData = require(ServerStorage.PlayerData)
local UpgradeData = require(ServerStorage.UpgradeData)

local PrefabFolder = ReplicatedStorage.ValuablesPrefabs

local LargeGemPrefab = PrefabFolder.LargeGem
local MediumGemPrefab = PrefabFolder.MediumGem
local SmallGemPrefab = PrefabFolder.SmallGem
local GoldCoinPrefab = PrefabFolder.GoldCoin
local SilverCoinPrefab = PrefabFolder.SilverCoin
local CopperCoinPrefab = PrefabFolder.CopperCoin
local ElectricGemPrefab = PrefabFolder.ElectricGem
local LuckGemPrefab = PrefabFolder.LuckGem

local COOLDOWN = 1
local NOZZLE_MAX_ANGLE = 90
local STRENGTH = 75
local MAX_VALUABLES = 100

local ELECTRIC_GEM_CHANCE = 0.002
local LUCK_GEM_CHANCE = 0.002

local level = 1

local function randomFloat(low, high)
	return math.random()*(high - low) + low
end

local function createValuable(level, isLuckBoosted)
	
	local r = randomFloat(0, 1)

	if r <= ELECTRIC_GEM_CHANCE then
		return ElectricGemPrefab:Clone()
	end
	
	r = r - ELECTRIC_GEM_CHANCE
	
	if r <= LUCK_GEM_CHANCE then
		return LuckGemPrefab:Clone()
	end

	local data = UpgradeData.CalculateValuablePercentages(level)

	local copperPercent = data[UpgradeData.COPPER_KEY]
	local silverPercent = data[UpgradeData.SILVER_KEY]
	local goldPercent = data[UpgradeData.GOLD_KEY]
	local diamondPercent = data[UpgradeData.DIAMOND_KEY]
	local amethystPercent = data[UpgradeData.AMETHYST_KEY]
	local rubyPercent = data[UpgradeData.RUBY_KEY]

	r = randomFloat(0, 1)
	if isLuckBoosted then
		r = r*r
	end

	if r <= rubyPercent then
		return LargeGemPrefab:Clone()
	end
	r = r - rubyPercent
	if r <= amethystPercent then
		return MediumGemPrefab:Clone()
	end
	r = r - amethystPercent
	if r <= diamondPercent then
		return SmallGemPrefab:Clone()
	end
	r = r - diamondPercent
	if r <= goldPercent then
		return GoldCoinPrefab:Clone()
	end
	r = r - goldPercent
	if r <= silverPercent then
		return SilverCoinPrefab:Clone()
	end
	return CopperCoinPrefab:Clone()
end

local function rotateVectorAround(v, amount, axis)
	return CFrame.fromAxisAngle(axis, math.rad(amount)):VectorToWorldSpace(v)
end

local function startFountainLoop(tycoon)
	local ValuablesFolder = tycoon.Valuables
	
	while true do
		if #ValuablesFolder:GetChildren() >= MAX_VALUABLES then
			task.wait(COOLDOWN)
			continue
		end
		
		local tycoonOwner = TycoonOwnershipData.GetPlayerFromTycoon(tycoon)
		
		if tycoonOwner == nil then
			task.wait(COOLDOWN)
			continue
		end
		
		local genRateDelay = UpgradeData.CalculateGenerationDelay(PlayerData.getValue(tycoonOwner, PlayerData.RATE_LEVEL_KEY_NAME))

		local ownerLevel = PlayerData.getValue(tycoonOwner, PlayerData.LEVEL_KEY_NAME)
		
		local lastLuckBoost = PlayerData.getValue(tycoonOwner, PlayerData.BOOSTS_KEY_NAME)[PlayerData.LUCK_BOOST_KEY]
		local isLuckBoosted = false
		if lastLuckBoost then
			isLuckBoosted = os.time() - lastLuckBoost <= 15
		end

		local valuable = createValuable(ownerLevel, isLuckBoosted)
		valuable.Parent = ValuablesFolder

		local hitbox = tycoon.MoneyFountain:WaitForChild("MoneyFountainModel"):WaitForChild("Hitbox")
		local nozzle = hitbox:FindFirstChild("Nozzle")

		if nozzle then
			local pos = Vector3.new(nozzle.Position.X, nozzle.Position.Y, nozzle.Position.Z)
			local orthVector = nozzle.CFrame.LookVector
			local velocity = (nozzle.CFrame * CFrame.Angles(0, -math.pi / 2, 0)).LookVector
			local velUnit = velocity.Unit
			velocity = velUnit * STRENGTH

			local customSpread = nozzle:FindFirstChild("SpreadDegrees")
			if customSpread then
				velocity = rotateVectorAround(velocity, customSpread.Value/2, orthVector)
			else
				velocity = rotateVectorAround(velocity, NOZZLE_MAX_ANGLE/2, orthVector)
			end

			velocity = rotateVectorAround(velocity, randomFloat(0, 360), velUnit)
			valuable.Position = pos
			valuable.AssemblyLinearVelocity = velocity
		else
			local pos = Vector3.new(hitbox.Position.X, hitbox.Position.Y + hitbox.Size.Y/2 + 1, hitbox.Position.Z)
			local velocity = Vector3.new(0, STRENGTH, 0)
			velocity = rotateVectorAround(velocity, randomFloat(0, NOZZLE_MAX_ANGLE/2), Vector3.new(1, 0, 0))
			velocity = rotateVectorAround(velocity, randomFloat(0, 360), Vector3.new(0, 1, 0))
			valuable.Position = pos
			valuable.AssemblyLinearVelocity = velocity
		end

		local lastSpeedBoostTime = PlayerData.getValue(tycoonOwner, PlayerData.BOOSTS_KEY_NAME)[PlayerData.SPEED_BOOST_KEY]
		if lastSpeedBoostTime then
			if os.time() - lastSpeedBoostTime <= 15 then
				task.wait(genRateDelay/2)
			else
				task.wait(genRateDelay)
			end
		else
			task.wait(genRateDelay)
		end
	end
end

local tycoonFolder = script.Parent

for _, tycoonPlot in pairs(tycoonFolder:GetChildren()) do
	if not tycoonPlot:IsA("Folder") then
		continue
	end
	
	task.spawn(function()
		startFountainLoop(tycoonPlot.Tycoon)
	end)
end