if getgenv().executed then return end

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Target;
local TargetCFrame;

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
end)

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
