if getgenv().executed then return end

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Target;
local TargetCFrame;

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
end)

function ServerHop()
	local PlaceID = game.PlaceId
	local AllIDs = {}
	local foundAnything = ""
	local actualHour = os.date("!*t").hour
	local Deleted = false
	local File = pcall(function()
    	AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
	end)
	if not File then
    	table.insert(AllIDs, actualHour)
    	writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
	end
	function TPReturner()
    	local Site;
    	if foundAnything == "" then
        	Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    	else
        	Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    	end
    	local ID = ""
    	if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        	foundAnything = Site.nextPageCursor
    	end
    	local num = 0;
    	for i,v in pairs(Site.data) do
        	local Possible = true
        	ID = tostring(v.id)
        	if tonumber(v.maxPlayers) > tonumber(v.playing) then
            	for _,Existing in pairs(AllIDs) do
                	if num ~= 0 then
                    	if ID == tostring(Existing) then
                        	Possible = false
                    	end
                	else
                    	if tonumber(actualHour) ~= tonumber(Existing) then
                        	local delFile = pcall(function()
                            	delfile("NotSameServers.json")
                            	AllIDs = {}
                            	table.insert(AllIDs, actualHour)
                        	end)
                    	end
                	end
                	num = num + 1
            	end
            	if Possible == true then
                	table.insert(AllIDs, ID)
                	wait()
                	pcall(function()
                    	writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    	wait()
                    	game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                	end)
                	wait(4)
            	end
        	end
    	end
	end

	while wait() do
    	pcall(function()
        	TPReturner()
        	if foundAnything ~= "" then
            	TPReturner()
        	end
    	end)
	end
end

function findClosestPlayer()
    local closest_player = nil
    local dist = math.huge

    for index, player in next, Players:GetPlayers() do
    	local Char = player.Character or player.CharacterAdded:Wait()
        local Humanoid = Char and Char:FindFirstChildWhichIsA('Humanoid')
        local HumanoidRootPart = Char and Char:FindFirstChild('HumanoidRootPart')
        
        if not Humanoid or not HumanoidRootPart or player == LocalPlayer then
            continue
        end
        
        if shared.config.bladeball.alive_check and workspace.Dead:FindFirstChild(player.Name) then
        	continue
        end
        
        if Humanoid.Health <= 0 then
            continue
        end

        local mag = (Character:FindFirstChild('HumanoidRootPart').Position - Char:FindFirstChild('HumanoidRootPart').Position).Magnitude
        if mag < dist then
        	dist = mag
            closest_player = player
        end
    end
    return closest_player
end

function findFarthestPlayer()
    local farthest_player = nil
    local dist = math.huge

    for index, player in next, Players:GetPlayers() do
    	local Char = player.Character or player.CharacterAdded:Wait()
        local Humanoid = Char and Char:FindFirstChildWhichIsA('Humanoid')
        local HumanoidRootPart = Char and Char:FindFirstChild('HumanoidRootPart')
        
        if not Humanoid or not HumanoidRootPart or player == LocalPlayer then
            continue
        end
        
        if shared.config.bladeball.alive_check and workspace.Dead:FindFirstChild(player.Name) then
        	continue
        end
        
        if Humanoid.Health <= 0 then
            continue
        end

        local mag = (Character:FindFirstChild('HumanoidRootPart').Position - Char:FindFirstChild('HumanoidRootPart').Position).Magnitude
        if mag > dist then
        	dist = mag
            closest_player = player
        end
    end
    return farthest_player
end

function findBallTarget()
	local ball_target
	
	for index, ball in pairs(workspace.Balls:GetChildren()) do
        if ball:GetAttribute("realBall") == true then
        	if ball:GetAttribute("target") == LocalPlayer.Name then
            	ball_target = findClosestPlayer()
            else
            	ball_target = Players:FindFirstChild(ball:GetAttribute("target"))
            end
        end
    end
    return ball_target
end

game:GetService('RunService').PostSimulation:Connect(function()
	if shared.config.serverhop.enabled then
		if #Players:GetPlayers() >= shared.config.serverhop.player_threshold then
			ServerHop()
		end
	end

    if shared.config.player_detection == 'Closest' then
        Target = findClosestPlayer()
    elseif shared.config.player_detection == 'Farthest' then
        Target = findFarthestPlayer()
    else
        Target = findBallTarget()
    end
    
    if game.PlaceId == 13772394625 then
    	if shared.config.bladeball.local_alive_check and not workspace.Alive:FindFirstChild(LocalPlayer.Name) then
    		return
    	end
    end
    
    if shared.config.auto_jump then
    	keypress(0x20)
    end

    if shared.config.enabled and Target then
    	if shared.config.position == 'Behind' then
    		TargetCFrame = Target.Character:FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(0, 0, shared.config.position_offset)
        elseif shared.config.position == 'Front' then
        	TargetCFrame = Target.Character:FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(0, 0, -shared.config.position_offset)
        else
        	TargetCFrame = Target.Character:FindFirstChild('HumanoidRootPart').CFrame
        end
        Character:FindFirstChild('Humanoid'):MoveTo(TargetCFrame.Position)
    end
end)

for i,v in pairs(getconnections(LocalPlayer.Idled)) do
   v:Disable()
end

getgenv().executed = true
