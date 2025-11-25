local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Variabel Konfigurasi
local clickPosition = nil
local isAutoClicking = false
local clickMode = "regular" -- "regular" atau "ultra"
local regularSpeed = 0.1 -- Kecepatan regular (detik per click)
local ultraSpeed = 0.01 -- Kecepatan ultra fast (detik per click)
local customizeMode = false

-- Membuat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner untuk MainFrame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.BorderSizePixel = 0
Title.Text = "Auto Clicker - ValkHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Button Set Position
local SetPosButton = Instance.new("TextButton")
SetPosButton.Name = "SetPosButton"
SetPosButton.Size = UDim2.new(0, 260, 0, 40)
SetPosButton.Position = UDim2.new(0, 20, 0, 55)
SetPosButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
SetPosButton.BorderSizePixel = 0
SetPosButton.Text = "📍 Set Click Position"
SetPosButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SetPosButton.TextSize = 16
SetPosButton.Font = Enum.Font.GothamSemibold
SetPosButton.Parent = MainFrame

local SetPosCorner = Instance.new("UICorner")
SetPosCorner.CornerRadius = UDim.new(0, 8)
SetPosCorner.Parent = SetPosButton

-- Button Regular Mode
local RegularButton = Instance.new("TextButton")
RegularButton.Name = "RegularButton"
RegularButton.Size = UDim2.new(0, 260, 0, 40)
RegularButton.Position = UDim2.new(0, 20, 0, 105)
RegularButton.BackgroundColor3 = Color3.fromRGB(60, 179, 113)
RegularButton.BorderSizePixel = 0
RegularButton.Text = "⚡ Regular Auto Clicker (0.1s)"
RegularButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RegularButton.TextSize = 16
RegularButton.Font = Enum.Font.GothamSemibold
RegularButton.Parent = MainFrame

local RegularCorner = Instance.new("UICorner")
RegularCorner.CornerRadius = UDim.new(0, 8)
RegularCorner.Parent = RegularButton

-- Button Ultra Fast Mode
local UltraButton = Instance.new("TextButton")
UltraButton.Name = "UltraButton"
UltraButton.Size = UDim2.new(0, 260, 0, 40)
UltraButton.Position = UDim2.new(0, 20, 0, 155)
UltraButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
UltraButton.BorderSizePixel = 0
UltraButton.Text = "🚀 Ultra Fast Auto Clicker (0.01s)"
UltraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UltraButton.TextSize = 16
UltraButton.Font = Enum.Font.GothamSemibold
UltraButton.Parent = MainFrame

local UltraCorner = Instance.new("UICorner")
UltraCorner.CornerRadius = UDim.new(0, 8)
UltraCorner.Parent = UltraButton

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -40, 0, 30)
StatusLabel.Position = UDim2.new(0, 20, 0, 205)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Membuat Bulatan Penanda
local Indicator = Instance.new("Frame")
Indicator.Name = "ClickIndicator"
Indicator.Size = UDim2.new(0, 50, 0, 50)
Indicator.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
Indicator.BackgroundTransparency = 0.3
Indicator.BorderSizePixel = 3
Indicator.BorderColor3 = Color3.fromRGB(255, 255, 255)
Indicator.Visible = false
Indicator.Parent = ScreenGui

local IndicatorCorner = Instance.new("UICorner")
IndicatorCorner.CornerRadius = UDim.new(1, 0)
IndicatorCorner.Parent = Indicator

-- Inner circle untuk efek
local InnerCircle = Instance.new("Frame")
InnerCircle.Name = "InnerCircle"
InnerCircle.Size = UDim2.new(0, 20, 0, 20)
InnerCircle.Position = UDim2.new(0.5, -10, 0.5, -10)
InnerCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InnerCircle.BackgroundTransparency = 0.5
InnerCircle.BorderSizePixel = 0
InnerCircle.Parent = Indicator

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(1, 0)
InnerCorner.Parent = InnerCircle

-- Fungsi untuk update status
local function updateStatus(text, color)
    StatusLabel.Text = "Status: " .. text
    StatusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

-- Fungsi untuk simulasi click
local function clickAtPosition()
    if clickPosition then
        mouse1click()
    end
end

-- Fungsi Set Position
SetPosButton.MouseButton1Click:Connect(function()
    customizeMode = not customizeMode
    
    if customizeMode then
        SetPosButton.Text = "✓ Click Anywhere to Set"
        SetPosButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        Indicator.Visible = true
        updateStatus("Customize Mode", Color3.fromRGB(255, 165, 0))
        
        -- Update posisi indikator mengikuti mouse
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if customizeMode then
                Indicator.Position = UDim2.new(0, mouse.X - 25, 0, mouse.Y - 25)
            else
                connection:Disconnect()
            end
        end)
    else
        SetPosButton.Text = "Set Click Position"
        SetPosButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    end
end)

-- Fungsi untuk set posisi ketika click
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if customizeMode and input.UserInputType == Enum.UserInputType.MouseButton1 then
        clickPosition = Vector2.new(mouse.X, mouse.Y)
        customizeMode = false
        SetPosButton.Text = "Position Set!"
        SetPosButton.BackgroundColor3 = Color3.fromRGB(60, 179, 113)
        
        -- Posisikan indikator di tempat yang diklik
        Indicator.Position = UDim2.new(0, clickPosition.X - 25, 0, clickPosition.Y - 25)
        Indicator.Visible = true
        
        updateStatus("Position Set!", Color3.fromRGB(60, 179, 113))
        
        wait(1)
        SetPosButton.Text = "Set Click Position"
        SetPosButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    end
end)

-- Regular Auto Clicker
RegularButton.MouseButton1Click:Connect(function()
    if not clickPosition then
        updateStatus("Set position first!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    clickMode = "regular"
    isAutoClicking = not isAutoClicking
    
    if isAutoClicking then
        RegularButton.Text = "Stop Basic Clicker"
        RegularButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        UltraButton.Visible = false
        updateStatus("Regular Clicking...", Color3.fromRGB(60, 179, 113))
        
        spawn(function()
            while isAutoClicking and clickMode == "regular" do
                clickAtPosition()
                wait(regularSpeed)
            end
        end)
    else
        RegularButton.Text = "Basic Clicker"
        RegularButton.BackgroundColor3 = Color3.fromRGB(60, 179, 113)
        UltraButton.Visible = true
        updateStatus("Stopped", Color3.fromRGB(200, 200, 200))
    end
end)

-- Ultra Fast Auto Clicker
UltraButton.MouseButton1Click:Connect(function()
    if not clickPosition then
        updateStatus("Set position first!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    clickMode = "ultra"
    isAutoClicking = not isAutoClicking
    
    if isAutoClicking then
        UltraButton.Text = "Stop Ultra Clicker"
        UltraButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        RegularButton.Visible = false
        updateStatus("Ultra Fast Clicking!", Color3.fromRGB(220, 20, 60))
        
        spawn(function()
            while isAutoClicking and clickMode == "ultra" do
                clickAtPosition()
                wait(ultraSpeed)
            end
        end)
    else
        UltraButton.Text = "Ultra Fast"
        UltraButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
        RegularButton.Visible = true
        updateStatus("Stopped", Color3.fromRGB(200, 200, 200))
    end
end)

-- Animasi pulse untuk indikator ketika clicking
spawn(function()
    while wait(0.5) do
        if isAutoClicking and Indicator.Visible then
            local tween = TweenService:Create(
                Indicator,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {BackgroundTransparency = 0.7}
            )
            tween:Play()
            tween.Completed:Wait()
            
            local tween2 = TweenService:Create(
                Indicator,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {BackgroundTransparency = 0.3}
            )
            tween2:Play()
        end
    end
end)
