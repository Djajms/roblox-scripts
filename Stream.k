-- Конфигурация координат базы и безопасной скорости
local baseCoordinates = Vector3.new(100, 10, -250) 
local tweenSpeed = 150 

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

-- Ждем загрузки интерфейса игрока (PlayerGui вместо CoreGui)
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Создание GUI интерфейса
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BypassTeleportGui_Fixed"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 160, 0, 50)
teleportButton.Position = UDim2.new(0.2, 0, 0.2, 0) -- Сместили позицию, чтобы точно было видно
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) 
teleportButton.Text = "БЕЗОПАСНЫЙ ТЛЕПОРТ"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextSize = 14
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.Active = true
teleportButton.Draggable = true
teleportButton.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = teleportButton

-- Основная функция обхода античита через плавный Tween
local function bypassTeleport()
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if rootPart and humanoid then
        local currentPos = rootPart.Position
        local distance = (baseCoordinates - currentPos).Magnitude
        local duration = distance / tweenSpeed
        
        local oldGravity = Workspace.Gravity
        Workspace.Gravity = 0
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        local skyPos = CFrame.new(currentPos.X, currentPos.Y + 50, currentPos.Z)
        rootPart.CFrame = skyPos
        task.wait(0.05)
        
        local targetCFrame = CFrame.new(baseCoordinates.X, baseCoordinates.Y + 50, baseCoordinates.Z)
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
        
        tween:Play()
        tween.Completed:Wait()
        
        rootPart.CFrame = CFrame.new(baseCoordinates)
        task.wait(0.1)
        
        Workspace.Gravity = oldGravity
        humanoid:ChangeState(Enum.HumanoidStateType.None)
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

teleportButton.MouseButton1Click:Connect(function()
    bypassTeleport()
end)
