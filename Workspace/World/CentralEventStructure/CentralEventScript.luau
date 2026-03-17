local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local WaterDropSound = SoundService.WaterDrop

local CloudPrefab = ReplicatedStorage.CloudPrefab
local ValuablesFolder = script.Parent.Valuables

local copperScalingCoin = ReplicatedStorage.ScalingCoinPrefabs.CopperScalingCoin
local silverScalingCoin = ReplicatedStorage.ScalingCoinPrefabs.SilverScalingCoin
local goldScalingCoin = ReplicatedStorage.ScalingCoinPrefabs.GoldScalingCoin
	
local waitTime = script:WaitForChild("WaitTime")

local function getRandomPoint(spawnRadiusPart)
	local center = spawnRadiusPart.CFrame.Position
	local radius = spawnRadiusPart.Size.Z / 2
	
	local randomAngle = math.random() * 2 * math.pi
	local randomDistance = math.sqrt(math.random()) * radius
	local offsetX = randomDistance * math.cos(randomAngle)
	local offsetY = 0
	local offsetZ = randomDistance * math.sin(randomAngle)
	return Vector3.new(center.X + offsetX, center.Y + offsetY, center.Z + offsetZ)
end

local function spawnValuable()
	local r = math.random()
	if r <= 0.75 then
		return copperScalingCoin:Clone()
	elseif r <= 0.95 then
		return silverScalingCoin:Clone()
	else
		return goldScalingCoin:Clone()
	end
end

local cloud = CloudPrefab:Clone()
cloud.Parent = script.Parent
cloud:PivotTo(CFrame.new(getRandomPoint(script.Parent.SpawnRadius)))
cloud.PrimaryPart.Transparency = 1

while true do
	
	waitTime.Value = 300
	while waitTime.Value >= 0 do
		task.wait(1)
		waitTime.Value -= 1
	end
	waitTime.Value = 0
	
	local goal = {}
	goal.Transparency = 0
	local tweenInfo = TweenInfo.new(
		5,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false
	)
	
	local tweenIn = TweenService:Create(cloud.PrimaryPart, tweenInfo, goal)
	tweenIn:Play()
	tweenIn.Completed:Wait()
	task.wait(3)
	
	for _ = 1, 10, 1 do
		local goal = {}
		goal.CFrame = CFrame.new(getRandomPoint(script.Parent.SpawnRadius))
		
		local tweenInfo = TweenInfo.new(
			1,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.InOut,
			0,
			false
		)
		
		local tweenMain = TweenService:Create(cloud.PrimaryPart, tweenInfo, goal)
		local tweenSpawnRadius = TweenService:Create(cloud.SpawnRadius, tweenInfo, goal)
		tweenMain:Play()
		tweenSpawnRadius:Play()
		tweenSpawnRadius.Completed:Wait()
		cloud.SpawnRadius.Rotation = Vector3.new(90, 90, 0)

		task.wait(1)
		for i = 1, 5, 1 do
			local newCoin = spawnValuable()
			local position = getRandomPoint(cloud.SpawnRadius)
			newCoin:PivotTo(CFrame.new(position))
			newCoin.Parent = ValuablesFolder
			
			local newSound = WaterDropSound:Clone()
			newSound.Parent = cloud.PrimaryPart
			newSound.PlayOnRemove = true
			newSound:Destroy()
			
			task.wait(0.33)
		end
		task.wait(1)
	end
	
	goal = {}
	goal.Transparency = 1
	local tweenInfo = TweenInfo.new(
		5,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false
	)

	local tweenOut = TweenService:Create(cloud.PrimaryPart, tweenInfo, goal)
	tweenOut:Play()
end