local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Speed threshold in studs per second
local SPEED_THRESHOLD = 50
-- Animation ID to play when speed threshold is exceeded
local ANIMATION_ID = "rbxassetid://18493678402"

-- Function to play the animation on the character
local function playSpeedAnimation(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = humanoid
        end

        local animation = Instance.new("Animation")
        animation.AnimationId = ANIMATION_ID

        local animationTrack = animator:LoadAnimation(animation)
        animationTrack:Play()
    end
end

-- Function to monitor the player's speed
local function monitorPlayerSpeed(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local lastPosition = character:GetPivot().Position
    local lastTime = tick()

    RunService.Heartbeat:Connect(function()
        if character.Parent then
            local currentPosition = character:GetPivot().Position
            local currentTime = tick()

            local distance = (currentPosition - lastPosition).Magnitude
            local timeElapsed = currentTime - lastTime
            local speed = distance / timeElapsed

            if speed > SPEED_THRESHOLD then
                playSpeedAnimation(character)
            end
			
            lastPosition = currentPosition
            lastTime = currentTime
        end
    end)
end

-- Bind the speed monitoring function to new and existing players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        monitorPlayerSpeed(player)
    end)
end)

for _, player in Players:GetPlayers() do
    player.CharacterAdded:Connect(function()
        monitorPlayerSpeed(player)
    end)
end