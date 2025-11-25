local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Variabel Konfigurasi
local clickPosition = nil
local isAutoClicking = false
local clickMode = "regular"
local regularSpeed = 0.1
local ultraSpeed = 0.01
local customizeMode = false
local isMinimized = false
local renderConnection = nil

-- Membuat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Title Text
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Auto Clicker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -65, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -32, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -45)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Set Position Button
local SetPosButton = Instance.new("TextButton")
SetPosButton.Name = "SetPosButton"
SetPosButton.Size = UDim2.new(1, 0, 0, 35)
SetPosButton.Position = UDim2.new(0, 0, 0, 0)
SetPosButton.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
SetPosButton.BorderSizePixel = 0
SetPosButton.Text = "Set Click Position"
SetPosButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SetPosButton.TextSize = 14
SetPosButton.Font = Enum.Font.GothamSemibold
SetPosButton.Parent = ContentFrame

local SetPosCorner = Instance.new("UICorner")
SetPosCorner.CornerRadius = UDim.new(0, 6)
SetPosCorner.Parent = SetPosButton

-- Confirm Button (Hidden initially)
local ConfirmButton = Instance.new("TextButton")
ConfirmButton.Name = "ConfirmButton"
ConfirmButton.Size = UDim2.new(0.48, 0, 0, 35)
ConfirmButton.Position = UDim2.new(0, 0, 0, 0)
ConfirmButton.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
ConfirmButton.BorderSizePixel = 0
ConfirmButton.Text = "Confirm"
ConfirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmButton.TextSize = 14
ConfirmButton.Font = Enum.Font.GothamSemibold
ConfirmButton.Visible = false
ConfirmButton.Parent = ContentFrame

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 6)
ConfirmCorner.Parent = ConfirmButton

-- Cancel Button (Hidden initially)
local CancelButton = Instance.new("TextButton")
CancelButton.Name = "CancelButton"
CancelButton.Size = UDim2.new(0.48, 0, 0, 35)
CancelButton.Position = UDim2.new(0.52, 0, 0, 0)
CancelButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
CancelButton.BorderSizePixel = 0
CancelButton.Text = "Cancel"
CancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelButton.TextSize = 14
CancelButton.Font = Enum.Font.GothamSemibold
CancelButton.Visible = false
CancelButton.Parent = ContentFrame

local CancelCorner = Instance.new("UICorner")
CancelCorner.CornerRadius = UDim.new(0, 6)
CancelCorner.Parent = CancelButton

-- Regular Clicker Button
local RegularButton = Instance.new("TextButton")
RegularButton.Name = "RegularButton"
RegularButton.Size = UDim2.new(1, 0, 0, 35)
RegularButton.Position = UDim2.new(0, 0, 0, 45)
RegularButton.BackgroundColor3 = Color3.fromRGB(60, 160, 100)
RegularButton.BorderSizePixel = 0
RegularButton.Text = "Regular Clicker: OFF"
RegularButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RegularButton.TextSize = 14
RegularButton.Font = Enum.Font.GothamSemibold
RegularButton.Parent = ContentFrame

local RegularCorner = Instance.new("UICorner")
RegularCorner.CornerRadius = UDim.new(0, 6)
RegularCorner.Parent = RegularButton

-- Ultra Fast Section Label
local UltraLabel = Instance.new("TextLabel")
UltraLabel.Name = "UltraLabel"
UltraLabel.Size = UDim2.new(1, 0, 0, 25)
UltraLabel.Position = UDim2.new(0, 0, 0, 90)
UltraLabel.BackgroundTransparency = 1
UltraLabel.Text = "Ultra Fast Clicker"
UltraLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
UltraLabel.TextSize = 13
UltraLabel.Font = Enum.Font.GothamBold
UltraLabel.TextXAlignment = Enum.TextXAlignment.Left
UltraLabel.Parent = ContentFrame

-- Speed Input
local SpeedInput = Instance.new("TextBox")
SpeedInput.Name = "SpeedInput"
SpeedInput.Size = UDim2.new(1, 0, 0, 30)
SpeedInput.Position = UDim2.new(0, 0, 0, 120)
SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpeedInput.BorderSizePixel = 0
SpeedInput.Text = "0.01"
SpeedInput.PlaceholderText = "Speed (0.00001 - 0.001)"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.TextSize = 13
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.Parent = ContentFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedInput

-- Speed Confirm Button
local SpeedConfirmButton = Instance.new("TextButton")
SpeedConfirmButton.Name = "SpeedConfirmButton"
SpeedConfirmButton.Size = UDim2.new(1, 0, 0, 30)
SpeedConfirmButton.Position = UDim2.new(0, 0, 0, 158)
SpeedConfirmButton.BackgroundColor3 = Color3.fromRGB(80, 140, 200)
SpeedConfirmButton.BorderSizePixel = 0
SpeedConfirmButton.Text = "Confirm Speed"
SpeedConfirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedConfirmButton.TextSize = 13
SpeedConfirmButton.Font = Enum.Font.GothamSemibold
SpeedConfirmButton.Parent = ContentFrame

local SpeedConfirmCorner = Instance.new("UICorner")
SpeedConfirmCorner.CornerRadius = UDim.new(0, 6)
SpeedConfirmCorner.Parent = SpeedConfirmButton

-- Ultra Fast Button
local UltraButton = Instance.new("TextButton")
UltraButton.Name = "UltraButton"
UltraButton.Size = UDim2.new(1, 0, 0, 35)
UltraButton.Position = UDim2.new(0, 0, 0, 196)
UltraButton.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
UltraButton.BorderSizePixel = 0
UltraButton.Text = "Ultra Fast: OFF"
UltraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UltraButton.TextSize = 14
UltraButton.Font = Enum.Font.GothamSemibold
UltraButton.Parent = ContentFrame

local UltraCorner = Instance.new("UICorner")
UltraCorner.CornerRadius = UDim.new(0, 6)
UltraCorner.Parent = UltraButton

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 35)
StatusLabel.Position = UDim2.new(0, 0, 0, 240)
StatusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatusLabel.BorderSizePixel = 0
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = ContentFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusLabel

-- Minimize Frame (Hidden initially)
local MinimizeFrame = Instance.new("TextButton")
MinimizeFrame.Name = "MinimizeFrame"
MinimizeFrame.Size = UDim2.new(0, 50, 0, 50)
MinimizeFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
MinimizeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinimizeFrame.BorderSizePixel = 2
MinimizeFrame.BorderColor3 = Color3.fromRGB(60, 120, 180)
MinimizeFrame.Text = "AC"
MinimizeFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeFrame.TextSize = 16
MinimizeFrame.Font = Enum.Font.GothamBold
MinimizeFrame.Visible = false
MinimizeFrame.Active = true
MinimizeFrame.Draggable = true
MinimizeFrame.Parent = ScreenGui

local MinFrameCorner = Instance.new("UICorner")
MinFrameCorner.CornerRadius = UDim.new(0, 8)
MinFrameCorner.Parent = MinimizeFrame

-- Click Indicator (Cursor)
local Indicator = Instance.new("ImageLabel")
Indicator.Name = "ClickIndicator"
Indicator.Size = UDim2.new(0, 20, 0, 20)
Indicator.BackgroundTransparency = 1
Indicator.Image = "rbxasset://textures/Cursors/KeyboardMouse/ArrowCursor.png"
Indicator.Visible = false
Indicator.Parent = ScreenGui

-- Fungsi Update Status
local function updateStatus(text, color)
    StatusLabel.Text = "Status: " .. text
    StatusLabel.TextColor3 = color or Color3.fromRGB(180, 180, 180)
end

-- Fungsi Click
local function performClick()
    if clickPosition then
        local virtualInputManager = game:GetService("VirtualInputManager")
        virtualInputManager:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, true, game, 0)
        wait()
        virtualInputManager:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, false, game, 0)
    end
end

-- Set Position Mode
SetPosButton.MouseButton1Click:Connect(function()
    if not customizeMode then
        customizeMode = true
        SetPosButton.Visible = false
        ConfirmButton.Visible = true
        CancelButton.Visible = true
        Indicator.Visible = true
        updateStatus("Select Click Position", Color3.fromRGB(255, 165, 0))
        
        if renderConnection then renderConnection:Disconnect() end
        renderConnection = RunService.RenderStepped:Connect(function()
            if customizeMode then
                Indicator.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
            end
        end)
    end
end)

-- Confirm Position
ConfirmButton.MouseButton1Click:Connect(function()
    clickPosition = Vector2.new(mouse.X, mouse.Y)
    customizeMode = false
    
    SetPosButton.Visible = true
    ConfirmButton.Visible = false
    CancelButton.Visible = false
    
    Indicator.Position = UDim2.new(0, clickPosition.X, 0, clickPosition.Y)
    Indicator.Visible = true
    
    if renderConnection then 
        renderConnection:Disconnect()
        renderConnection = nil
    end
    
    updateStatus("Position Set", Color3.fromRGB(60, 180, 100))
end)

-- Cancel Position
CancelButton.MouseButton1Click:Connect(function()
    customizeMode = false
    clickPosition = nil
    
    SetPosButton.Visible = true
    ConfirmButton.Visible = false
    CancelButton.Visible = false
    Indicator.Visible = false
    
    if renderConnection then 
        renderConnection:Disconnect()
        renderConnection = nil
    end
    
    updateStatus("Cancelled", Color3.fromRGB(180, 60, 60))
end)

-- Regular Clicker
RegularButton.MouseButton1Click:Connect(function()
    if not clickPosition then
        updateStatus("Set Position First", Color3.fromRGB(255, 100, 100))
        return
    end
    
    if clickMode == "ultra" and isAutoClicking then
        updateStatus("Stop Ultra First", Color3.fromRGB(255, 100, 100))
        return
    end
    
    clickMode = "regular"
    isAutoClicking = not isAutoClicking
    
    if isAutoClicking then
        RegularButton.Text = "Regular Clicker: ON"
        RegularButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        updateStatus("Regular Clicking", Color3.fromRGB(60, 180, 100))
        
        spawn(function()
            while isAutoClicking and clickMode == "regular" do
                performClick()
                wait(regularSpeed)
            end
        end)
    else
        RegularButton.Text = "Regular Clicker: OFF"
        RegularButton.BackgroundColor3 = Color3.fromRGB(60, 160, 100)
        updateStatus("Stopped", Color3.fromRGB(180, 180, 180))
    end
end)

-- Speed Confirm
SpeedConfirmButton.MouseButton1Click:Connect(function()
    local inputSpeed = tonumber(SpeedInput.Text)
    
    if inputSpeed and inputSpeed >= 0.00001 and inputSpeed <= 0.001 then
        ultraSpeed = inputSpeed
        SpeedConfirmButton.Text = "Speed: " .. tostring(ultraSpeed)
        SpeedConfirmButton.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        updateStatus("Speed Updated", Color3.fromRGB(60, 180, 100))
        
        wait(1)
        SpeedConfirmButton.Text = "Confirm Speed"
        SpeedConfirmButton.BackgroundColor3 = Color3.fromRGB(80, 140, 200)
    else
        updateStatus("Invalid Speed Range", Color3.fromRGB(255, 100, 100))
    end
end)

-- Ultra Fast Clicker
UltraButton.MouseButton1Click:Connect(function()
    if not clickPosition then
        updateStatus("Set Position First", Color3.fromRGB(255, 100, 100))
        return
    end
    
    if clickMode == "regular" and isAutoClicking then
        updateStatus("Stop Regular First", Color3.fromRGB(255, 100, 100))
        return
    end
    
    clickMode = "ultra"
    isAutoClicking = not isAutoClicking
    
    if isAutoClicking then
        UltraButton.Text = "Ultra Fast: ON"
        UltraButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        updateStatus("Ultra Clicking", Color3.fromRGB(200, 60, 80))
        
        spawn(function()
            while isAutoClicking and clickMode == "ultra" do
                performClick()
                wait(ultraSpeed)
            end
        end)
    else
        UltraButton.Text = "Ultra Fast: OFF"
        UltraButton.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
        updateStatus("Stopped", Color3.fromRGB(180, 180, 180))
    end
end)

-- Minimize
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Visible = not isMinimized
    MinimizeFrame.Visible = isMinimized
end)

-- Restore from Minimize
MinimizeFrame.MouseButton1Click:Connect(function()
    isMinimized = false
    MainFrame.Visible = true
    MinimizeFrame.Visible = false
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    isAutoClicking = false
    if renderConnection then renderConnection:Disconnect() end
    ScreenGui:Destroy()
end)
