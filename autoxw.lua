-- КОНФИГУРАЦИЯ СЕРВЕРА И КООРДИНАТ
local baseCoords = Vector3.new(100, 10, -250)
local brainrotName = "Brainrot"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Проверка на LocalScript環境 (Защита от ошибки выполнения)
if not localPlayer then 
    return 
end

-- ИСПРАВЛЕНИЕ №2: Безопасное уведомление с задержкой
task.wait(1)
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "HUB ЗАГРУЖЕН",
        Text = "Успешное подключение к системе!",
        Duration = 5
    })
end)

-- ИСПРАВЛЕНИЕ №6: Определение правильного родителя GUI для Delta X
local guiParent = (gethui and gethui()) or game:GetService("CoreGui")

-- СОЗДАНИЕ ГЛАВНОГО МЕНЮ (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VillagePremiumHub_Fixed"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 250)
-- ИСПРАВЛЕНИЕ №5: Статичная позиция, чтобы окно точно не улетело за экран смартфона
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.Text = "VILLAGE HUB v2.5"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- ШАБЛОН ДЛЯ СОЗДАНИЯ КНОПОК
local function createButton(text, pos, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 40)
    button.Position = pos
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    button.Parent = mainFrame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    button.MouseButton1Click:Connect(callback)
    return button
end

-- ИСПРАВЛЕНИЕ №3: Предварительное объявление переменных кнопок
local tpBtn
local flyBtn
local jumpBtn

local autoTpEnabled = false
local flyEnabled = false
local infJumpEnabled = false

-- 1. КНОПКА: АВТО-ТЕЛЕПОРТ
tpBtn = createButton("Авто-ТП: ВЫКЛ", UDim2.new(0, 10, 0, 55), Color3.fromRGB(180, 50, 50), function()
    autoTpEnabled = not autoTpEnabled
    if autoTpEnabled then
        tpBtn.Text = "Авто-ТП: ВКЛ"
        tpBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        tpBtn.Text = "Авто-ТП: ВЫКЛ"
        tpBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

local function safeTeleport()
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local tween = TweenService:Create(root, TweenInfo.new(3), {CFrame = CFrame.new(baseCoords)})
    tween:Play()
    tween.Completed:Wait()
end

RunService.Heartbeat:Connect(function()
    if autoTpEnabled then
        local char = localPlayer.Character
        if char and char:FindFirstChild(brainrotName) then
            safeTeleport()
        end
    end
end)

-- 2. КНОПКА: ПОЛЕТ (FLY)
flyBtn = createButton("Полет: ВЫКЛ", UDim2.new(0, 10, 0, 105), Color3.fromRGB(180, 50, 50), function()
    flyEnabled = not flyEnabled
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if flyEnabled then
        flyBtn.Text = "Полет: ВКЛ"
        flyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = "VillageFly"
        bv.MaxForce = Vector3.new(450000, 450000, 450000)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        
        task.spawn(function()
            while flyEnabled and root and bv.Parent do
                bv.Velocity = localPlayer:GetMouse().Hit.LookVector * 100
                task.wait(0.01)
            end
            bv:Destroy()
        end)
    else
        flyBtn.Text = "Полет: ВЫКЛ"
        flyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- 3. КНОПКА: ВЫСОКИЙ СУПЕР ПРЫЖОК
jumpBtn = createButton("Прыжки: ВЫКЛ", UDim2.new(0, 10, 0, 155), Color3.fromRGB(180, 50, 50), function()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        jumpBtn.Text = "Прыжки: ВКЛ"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        jumpBtn.Text = "Прыжки: ВЫКЛ"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = localPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 4. КНОПКА: ЗАКРЫТЬ МЕНЮ
createButton("ЗАКРЫТЬ МЕНЮ", UDim2.new(0, 10, 0, 205), Color3.fromRGB(80, 80, 80), function()
    screenGui:Destroy()
end)
