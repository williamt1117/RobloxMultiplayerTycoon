local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local TycoonOwnershipData = require(ServerStorage.TycoonOwnershipData)

local tycoonFolder = script.Parent

for _, tycoonPlot in pairs(tycoonFolder:GetChildren()) do
	if not tycoonPlot:IsA("Folder") then
		continue
	end
	
	local tycoon = tycoonPlot.Tycoon
	
	local button = tycoon.ClaimButton
	local OwnerDisplay = tycoon.ClaimButton.BillboardGui.OwnerDisplay
	
	local debounce = false
	
	local function onTouch(otherPart)
		if debounce then
			return
		end
		
		local character = otherPart.Parent
		local player = Players:GetPlayerFromCharacter(character)

		if not player then
			return
		end

		if not TycoonOwnershipData.AttemptClaim(player, tycoon) then
			print(player.Name .. " attempted to claim a second tycoon.")
			return
		end

		OwnerDisplay.Text = player.Name .. "'s Fountain"
		button.Transparency = 1
		button.CanCollide = false
		button.CanTouch = false
		
		debounce = true
		task.wait(3)
		debounce = false
	end
	
	button.Touched:Connect(function(otherPart)
		onTouch(otherPart)
	end)
end