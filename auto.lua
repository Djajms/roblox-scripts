-- Автоматический телепорт к базе через TweenService
local baseCoords = Vector3.new(100, 10, -250)
local brainrotName = "Brainrot"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local function safeTeleport()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Плавное перемещение (обход античита)
    local tween = TweenService:Create(root, TweenInfo.new(3), {CFrame = CFrame.new(baseCoords)})
    tween:Play()
    tween.Completed:Wait()
end

-- Авто-детект предмета в руках
game:GetService("RunService").Heartbeat:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild(brainrotName) then
        safeTeleport()
    end
end)
