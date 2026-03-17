local ServerStorage = game:GetService("ServerStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)

local assetId = 1087121781

local tycoonPlotFolder = script.Parent

for _, tycoonPlot in ipairs(tycoonPlotFolder:GetChildren()) do
	if not tycoonPlot:IsA("Folder") then
		continue
	end
	
	local tycoon = tycoonPlot.Tycoon
	local carpet = tycoon.Carpet
	local CarpetToggleProximityPrompt = tycoon.CarpetToggleButton.Button.ProximityPrompt
	
	--initialize by removing carpet
	carpet.Parent = nil
	local enabled = false
	
	CarpetToggleProximityPrompt.Triggered:Connect(function(player)
		local owner = TycoonOwnershipData.GetPlayerFromTycoon(tycoon)

		if player ~= owner then
			return
		end

		if enabled then
			--disable carpet
			carpet.Parent = nil
			enabled = false
			CarpetToggleProximityPrompt.ActionText = "Turn On Auto-Collect"
		else
			local hasPass
			local success, message = pcall(function()
				hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, assetId)
			end)
			if hasPass then
				--enable carpet
				carpet.Parent = tycoon
				enabled = true
				CarpetToggleProximityPrompt.ActionText = "Turn Off Auto-Collect"
			else
				MarketplaceService:PromptGamePassPurchase(player, assetId)
			end
		end
	end)

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function (...)
		local player, id, purchased = ...
		if not purchased then
			return
		end
		
		if TycoonOwnershipData.GetTycoon(player) ~= tycoon then
			return
		end

		if id == assetId then
			--enable carpet
			carpet.Parent = tycoon
			enabled = true
			CarpetToggleProximityPrompt.ActionText = "Turn Off Auto-Collect"
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		if TycoonOwnershipData.GetTycoon(player) ~= tycoon then
			return
		end
		
		--disable carpet
		carpet.Parent = nil
		enabled = false
		CarpetToggleProximityPrompt.ActionText = "Turn On Auto-Collect"
	end)
end