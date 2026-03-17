local ServerStorage = game:GetService("ServerStorage")

local GlobalLeaderboardData = require(ServerStorage.GlobalLeaderboardData)

local GlobalLeaderboardsFolder = script.Parent

local names = {"K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dd", "Ud", "Dd", "Td", "Qad", "Qid", 
	"Sxd", "Spd", "Ocd", "Nod", "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Spvg", "Ocvg"}
local pows = {}
for i = 1, #names do table.insert(pows, 1000^i) end

local function formatNumber(x: number): string 
	--use the absolute value to simplify calculations
	local ab = math.abs(x)
	--theres no need to convert numbers in the range -1000 < x < 1000
	if ab < 1000 then return tostring(x) end 
	--calculate the power of 1000 to use for division
	local p = math.min(math.floor(math.log10(ab)/3), #names)
	--calculate result using abs/1000^p and keep 2 decimal digits
	local num = math.floor(ab/pows[p]*100)/100
	--add back the sign if the number is negative and add the name at end
	return num*math.sign(x)..names[p]
end

while true do
	
	GlobalLeaderboardData.UpdateAllActivePlayers()
	
	local topTen = GlobalLeaderboardData.GetTopTenPlayers()
	
	for rank, data in ipairs(topTen) do
		local username = data.key
		local money = data.value
		
		for _, child in ipairs(GlobalLeaderboardsFolder:GetChildren()) do
			if child.name == "Leaderboard" then
				local leaderboardContainer = child.LeaderboardScreen.SurfaceGui.Frame.LeaderboardContainer
				local entryFrame = leaderboardContainer:FindFirstChild("Entry" .. rank)
				entryFrame.Username.Text = username
				entryFrame.Money.Text = formatNumber(money)
			end
		end
	end
	task.wait(15)
end