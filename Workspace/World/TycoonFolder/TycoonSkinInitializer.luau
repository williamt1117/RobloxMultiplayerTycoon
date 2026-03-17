local ServerStorage = game:GetService("ServerStorage")
local FountainSkinData = require(ServerStorage.FountainSkinData)

local tycoonFolder = script.Parent

for _, tycoonPlot in pairs(tycoonFolder:GetChildren()) do
	if tycoonPlot:IsA("Folder") then
		local tycoon = tycoonPlot.Tycoon
		FountainSkinData.InitializeTycoonSkins(tycoon)
	end
end