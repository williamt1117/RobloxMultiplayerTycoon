local UpgradeData = {}

local FULL_SILVER_LEVEL = 25
local FULL_GOLD_LEVEL = 60
local MEDIUM_GEM_START_LEVEL = 100
local LARGE_GEM_START_LEVEL = 125
local FINAL_LEVEL = 250

local MAX_SMALL_GEM_RATE = 0.5
local MAX_MEDIUM_GEM_RATE = 0.2
local MAX_LARGE_GEM_RATE = 0.05

UpgradeData.COPPER_KEY = "Copper"
UpgradeData.SILVER_KEY = "Silver"
UpgradeData.GOLD_KEY = "Gold"
UpgradeData.DIAMOND_KEY = "Diamond"
UpgradeData.AMETHYST_KEY = "Amethyst"
UpgradeData.RUBY_KEY = "Ruby"

function UpgradeData.CalculateValuablePercentages(level)
	local copperPercent = 0
	local silverPercent = 0
	local goldPercent = 0
	local diamondPercent = 0
	local amethystPercent = 0
	local rubyPercent = 0

	if level == 1 then
		copperPercent = 1
	elseif level <= FULL_SILVER_LEVEL then
		silverPercent = (1/FULL_SILVER_LEVEL)*level
		copperPercent = 1 - silverPercent
	elseif level <= FULL_GOLD_LEVEL then
		goldPercent = (1/(FULL_GOLD_LEVEL-FULL_SILVER_LEVEL))*(level - FULL_SILVER_LEVEL)
		silverPercent = 1 - goldPercent
	elseif level <= MEDIUM_GEM_START_LEVEL then
		diamondPercent = (MAX_SMALL_GEM_RATE/(FINAL_LEVEL - FULL_GOLD_LEVEL))*(level - FULL_GOLD_LEVEL)
		goldPercent = 1 - diamondPercent
	elseif level <= LARGE_GEM_START_LEVEL then
		amethystPercent = (MAX_MEDIUM_GEM_RATE/(FINAL_LEVEL - MEDIUM_GEM_START_LEVEL))*(level - MEDIUM_GEM_START_LEVEL)
		diamondPercent = (MAX_SMALL_GEM_RATE/(FINAL_LEVEL - FULL_GOLD_LEVEL))*(level - FULL_GOLD_LEVEL) - amethystPercent
		goldPercent = 1 - diamondPercent
	else --level <= FINAL_LEVEL and beyond
		rubyPercent = math.clamp((MAX_LARGE_GEM_RATE/(FINAL_LEVEL - LARGE_GEM_START_LEVEL))*(level - LARGE_GEM_START_LEVEL), 0, 1)
		amethystPercent = math.clamp(math.clamp((MAX_MEDIUM_GEM_RATE/(FINAL_LEVEL - MEDIUM_GEM_START_LEVEL))*(level - MEDIUM_GEM_START_LEVEL), 0, 1) - rubyPercent, 0, 1)
		diamondPercent = math.clamp(math.clamp((MAX_SMALL_GEM_RATE/(FINAL_LEVEL - FULL_GOLD_LEVEL))*(level - FULL_GOLD_LEVEL), 0, 1) - amethystPercent - rubyPercent, 0, 1)
		goldPercent = math.clamp(1 - diamondPercent - amethystPercent - rubyPercent, 0, 1)
	end
	
	local data = {
		[UpgradeData.COPPER_KEY] = copperPercent,
		[UpgradeData.SILVER_KEY] = silverPercent,
		[UpgradeData.GOLD_KEY] = goldPercent,
		[UpgradeData.DIAMOND_KEY] = diamondPercent,
		[UpgradeData.AMETHYST_KEY] = amethystPercent,
		[UpgradeData.RUBY_KEY] = rubyPercent
	}
	
	return data
end

function UpgradeData.CalculateGenerationDelay(rateLevel)
	return 0.9 * 2.718^(-0.05*(rateLevel-1)) + 0.1
end

function UpgradeData.GetLevelColor(level)
	local copperColor = Color3.new(170/255, 85/255, 0)
	local silverColor = Color3.new(123/255, 124/255, 134/255)
	local goldColor = Color3.new(195/255, 130/255, 0/255)
	local diamondColor = Color3.new(72/255, 193/255, 183/255)
	local amethystColor = Color3.new(180/255, 78/255, 193/255)
	local rubyColor = Color3.new(204/255, 30/255, 24/255)
	if level == 1 then
		return copperColor
	elseif level <= FULL_SILVER_LEVEL then
		return silverColor
	elseif level <= FULL_GOLD_LEVEL then
		return goldColor
	elseif level <= MEDIUM_GEM_START_LEVEL then
		return diamondColor
	elseif level <= LARGE_GEM_START_LEVEL then
		return amethystColor
	else --level <= FINAL_LEVEL
		return rubyColor
	end
end

return UpgradeData
