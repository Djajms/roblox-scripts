local baseCoordinates = Vector3.new(100, 10, -250) 
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui_UN"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 150, 0, 50)
teleportButton.Position = UDim2.new(0.1, 0, 0.4, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
teleportButton.Text = "ТЕЛЕПОРТ НА БАЗУ"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextSize = 16
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.Active = true
teleportButton.Draggable = true
teleportButton.Parent = screenGui
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = teleportButton
local function doTeleport()
    local character = localPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(baseCoordinates)
    end
end
teleportButton.MouseButton1Click:Connect(function()
    doTeleport()
end)
