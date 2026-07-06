-- Конфигурация координат базы и безопасной скорости
local baseCoordinates = Vector3.new(100, 10, -250) 
local tweenSpeed = 150 -- Безопасная скорость (изменяйте от 100 до 250, если будет кикать)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

-- Создание GUI интерфейса
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BypassTeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 160, 0, 50)
teleportButton.Position = UDim2.new(0.1, 0, 0.4, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Красный стиль обхода
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
        -- Вычисляем расстояние и время полета для стабильной скорости
        local currentPos = rootPart.Position
        local distance = (baseCoordinates - currentPos).Magnitude
        local duration = distance / tweenSpeed
        
        -- Временный обход физики: отключаем урон от падения и коллизии
        local oldGravity = Workspace.Gravity
        Workspace.Gravity = 0
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Сначала поднимаем игрока чуть выше, чтобы обойти препятствия (Sky-Walk)
        local skyPos = CFrame.new(currentPos.X, currentPos.Y + 50, currentPos.Z)
        rootPart.CFrame = skyPos
        task.wait(0.05)
        
        -- Плавный пролет до координат базы над землей
        local targetCFrame = CFrame.new(baseCoordinates.X, baseCoordinates.Y + 50, baseCoordinates.Z)
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
        
        tween:Play()
        tween.Completed:Wait() -- Ждем завершения полета
        
        -- Плавное опускание на саму базу
        rootPart.CFrame = CFrame.new(baseCoordinates)
        task.wait(0.1)
        
        -- Возвращаем физику в исходное состояние
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
