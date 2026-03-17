local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)

local function onDisconnect(player)
	local tycoon = TycoonOwnershipData.GetTycoon(player)
	
	if tycoon then
		--reenable claim button
		local button = tycoon.ClaimButton
		local OwnerDisplay = button.BillboardGui.OwnerDisplay
		OwnerDisplay.Text = "Stand Here to Claim!"
		button.Transparency = 0
		button.CanCollide = true
		button.CanTouch = true 
		
		--destroy all valuables
		local valuablesFolder = tycoon.Valuables
		for _, v in ipairs(valuablesFolder:GetChildren()) do
			if v.className == "Part" then
				v:Destroy()
			end
		end
	end
	
	TycoonOwnershipData.RemoveClaim(player)
end

Players.PlayerRemoving:Connect(function(player)
	onDisconnect((player))
end)