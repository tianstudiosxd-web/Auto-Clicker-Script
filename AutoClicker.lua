local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Variabel Status
local autoClickerEnabled = false
local clickSpeed = 1
local isRunning = true
local clickConnection
local cursorIndicator

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Proteksi agar tidak terdeteksi
if gethui then
    screenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(screenGui)
    screenGui.Parent = game.CoreGui
else
    screenGui.Parent = game.CoreGui
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 180)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Corner untuk Main Frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Shadow Effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.ZIndex = 0
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local topBarFix = Instance.new("Frame")
topBarFix.Size = UDim2.new(1, 0, 0, 10)
topBarFix.Position = UDim2.new(0, 0, 1, -10)
topBarFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
topBarFix.BorderSizePixel = 0
topBarFix.Parent = topBar

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Auto Clicker"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeBtn.Text = ""
minimizeBtn.Parent = topBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 0)
minCorner.Parent = minimizeBtn

local minIcon = Instance.new("TextLabel")
minIcon.Size = UDim2.new(1, 0, 1, 0)
minIcon.BackgroundTransparency = 1
minIcon.Text = "−"
minIcon.TextColor3 = Color3.fromRGB(0, 0, 0)
minIcon.TextSize = 18
minIcon.Font = Enum.Font.GothamBold
minIcon.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -25, 0.5, -12.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = ""
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 0)
closeCorner.Parent = closeBtn

local closeIcon = Instance.new("TextLabel")
closeIcon.Size = UDim2.new(1, 0, 1, 0)
closeIcon.BackgroundTransparency = 1
closeIcon.Text = "×"
closeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
closeIcon.TextSize = 20
closeIcon.Font = Enum.Font.GothamBold
closeIcon.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 5)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Click Speed (1-1000)"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = contentFrame

-- Speed Input
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(1, 0, 0, 30)
speedInput.Position = UDim2.new(0, 0, 0, 30)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
speedInput.Text = "1"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 14
speedInput.Font = Enum.Font.Gotham
speedInput.PlaceholderText = "1-1000"
speedInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
speedInput.Parent = contentFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 5)
inputCorner.Parent = speedInput

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 70)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = contentFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(1, 0, 0, 35)
toggleBtn.Position = UDim2.new(0, 0, 0, 95)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- Minimize Frame (kotak kecil)
local minimizedFrame = Instance.new("TextButton")
minimizedFrame.Name = "MinimizedFrame"
minimizedFrame.Size = UDim2.new(0, 40, 0, 40)
minimizedFrame.Position = UDim2.new(0.5, -20, 0.5, -20)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
minimizedFrame.Text = ""
minimizedFrame.Visible = false
minimizedFrame.Parent = screenGui

local minFrameCorner = Instance.new("UICorner")
minFrameCorner.CornerRadius = UDim.new(0, 0)
minFrameCorner.Parent = minimizedFrame

local minFrameIcon = Instance.new("TextLabel")
minFrameIcon.Size = UDim2.new(1, 0, 1, 0)
minFrameIcon.BackgroundTransparency = 1
minFrameIcon.Text = "+"
minFrameIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
minFrameIcon.TextSize = 24
minFrameIcon.Font = Enum.Font.GothamBold
minFrameIcon.Parent = minimizedFrame

-- Cursor Indicator (Penanda Kursor dengan Icon Kursor Asli)
local cursorFrame = Instance.new("Frame")
cursorFrame.Name = "CursorIndicator"
cursorFrame.Size = UDim2.new(0, 80, 0, 80)
cursorFrame.BackgroundTransparency = 1
cursorFrame.Visible = false
cursorFrame.Parent = screenGui

-- Outer Glow Circle (Efek Cahaya)
local outerGlow = Instance.new("Frame")
outerGlow.Name = "OuterGlow"
outerGlow.Size = UDim2.new(0, 60, 0, 60)
outerGlow.Position = UDim2.new(0, 10, 0, 10)
outerGlow.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
outerGlow.BackgroundTransparency = 0.7
outerGlow.BorderSizePixel = 0
outerGlow.Parent = cursorFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(1, 0)
glowCorner.Parent = outerGlow

local glowStroke = Instance.new("UIStroke")
glowStroke.Color = Color3.fromRGB(80, 255, 120)
glowStroke.Thickness = 3
glowStroke.Transparency = 0.3
glowStroke.Parent = outerGlow

-- Icon Kursor (Dibuat dengan Frame untuk membentuk pointer)
local cursorIcon = Instance.new("Frame")
cursorIcon.Name = "CursorIcon"
cursorIcon.Size = UDim2.new(0, 30, 0, 30)
cursorIcon.Position = UDim2.new(0, 25, 0, 25)
cursorIcon.BackgroundTransparency = 1
cursorIcon.Parent = cursorFrame

-- Bagian Pointer Kursor (Bentuk Segitiga/Arrow)
-- Badan Kursor (Vertikal)
local cursorBody = Instance.new("Frame")
cursorBody.Size = UDim2.new(0, 4, 0, 22)
cursorBody.Position = UDim2.new(0, 0, 0, 0)
cursorBody.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cursorBody.BorderSizePixel = 0
cursorBody.Rotation = 25
cursorBody.Parent = cursorIcon

local bodyStroke = Instance.new("UIStroke")
bodyStroke.Color = Color3.fromRGB(0, 0, 0)
bodyStroke.Thickness = 1
bodyStroke.Parent = cursorBody

-- Ujung Kursor Kiri
local cursorLeft = Instance.new("Frame")
cursorLeft.Size = UDim2.new(0, 4, 0, 12)
cursorLeft.Position = UDim2.new(0, 2, 0, 14)
cursorLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cursorLeft.BorderSizePixel = 0
cursorLeft.Rotation = -10
cursorLeft.Parent = cursorIcon

local leftStroke = Instance.new("UIStroke")
leftStroke.Color = Color3.fromRGB(0, 0, 0)
leftStroke.Thickness = 1
leftStroke.Parent = cursorLeft

-- Ujung Kursor Kanan
local cursorRight = Instance.new("Frame")
cursorRight.Size = UDim2.new(0, 4, 0, 12)
cursorRight.Position = UDim2.new(0, 8, 0, 10)
cursorRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cursorRight.BorderSizePixel = 0
cursorRight.Rotation = 55
cursorRight.Parent = cursorIcon

local rightStroke = Instance.new("UIStroke")
rightStroke.Color = Color3.fromRGB(0, 0, 0)
rightStroke.Thickness = 1
rightStroke.Parent = cursorRight

-- Click Indicator (Lingkaran yang muncul saat klik)
local clickIndicator = Instance.new("Frame")
clickIndicator.Name = "ClickIndicator"
clickIndicator.Size = UDim2.new(0, 15, 0, 15)
clickIndicator.Position = UDim2.new(0, 32, 0, 32)
clickIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 80)
clickIndicator.BackgroundTransparency = 1
clickIndicator.BorderSizePixel = 0
clickIndicator.Parent = cursorFrame

local clickCorner = Instance.new("UICorner")
clickCorner.CornerRadius = UDim.new(1, 0)
clickCorner.Parent = clickIndicator

local clickStroke = Instance.new("UIStroke")
clickStroke.Color = Color3.fromRGB(255, 255, 80)
clickStroke.Thickness = 3
clickStroke.Transparency = 1
clickStroke.Parent = clickIndicator

-- Animasi Pulse untuk Glow
local function startPulseAnimation()
    game:GetService("RunService").RenderStepped:Connect(function()
        if autoClickerEnabled then
            local time = tick() * 3
            local scale = 1 + math.sin(time) * 0.15
            outerGlow.Size = UDim2.new(0, 60 * scale, 0, 60 * scale)
            outerGlow.Position = UDim2.new(0, 10 + (60 - 60 * scale) / 2, 0, 10 + (60 - 60 * scale) / 2)
            
            -- Efek breathing pada transparency
            glowStroke.Transparency = 0.3 + math.sin(time) * 0.2
        end
    end)
end

-- Update Cursor Position
local function updateCursorPosition()
    game:GetService("RunService").RenderStepped:Connect(function()
        if cursorFrame.Visible then
            local mousePos = UserInputService:GetMouseLocation()
            cursorFrame.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
        end
    end)
end

updateCursorPosition()
startPulseAnimation()

-- Dragging Functionality
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Fungsi Auto Clicker
local function performClick()
    -- Visual feedback saat klik - animasi click indicator
    clickIndicator.BackgroundTransparency = 0
    clickStroke.Transparency = 0
    
    -- Animasi expand
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local expandTween = TweenService:Create(clickIndicator, tweenInfo, {
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(0, 22, 0, 22),
        BackgroundTransparency = 1
    })
    local strokeTween = TweenService:Create(clickStroke, tweenInfo, {
        Transparency = 1
    })
    
    expandTween:Play()
    strokeTween:Play()
    
    expandTween.Completed:Connect(function()
        clickIndicator.Size = UDim2.new(0, 15, 0, 15)
        clickIndicator.Position = UDim2.new(0, 32, 0, 32)
        clickIndicator.BackgroundTransparency = 1
        clickStroke.Transparency = 1
    end)
    
    mouse1click()
end

local function startAutoClicker()
    if clickConnection then
        clickConnection:Disconnect()
    end
    
    local delay = 1 / clickSpeed
    
    clickConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if autoClickerEnabled and isRunning then
            performClick()
            wait(delay)
        end
    end)
end

-- Toggle Button Function
toggleBtn.MouseButton1Click:Connect(function()
    local speedValue = tonumber(speedInput.Text)
    
    if not speedValue then
        statusLabel.Text = "Status: Invalid Input!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
        wait(2)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    if speedValue > 1000 then
        statusLabel.Text = "Status: Max 1000!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
        wait(2)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    if speedValue < 1 then
        statusLabel.Text = "Status: Min 1!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
        wait(2)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    autoClickerEnabled = not autoClickerEnabled
    clickSpeed = speedValue
    
    if autoClickerEnabled then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
        statusLabel.Text = "Status: ON (" .. clickSpeed .. " CPS)"
        statusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
        cursorFrame.Visible = true -- Tampilkan cursor indicator
        startAutoClicker()
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        cursorFrame.Visible = false -- Sembunyikan cursor indicator
        if clickConnection then
            clickConnection:Disconnect()
        end
    end
end)

-- Close Button Function
closeBtn.MouseButton1Click:Connect(function()
    isRunning = false
    autoClickerEnabled = false
    cursorFrame.Visible = false -- Sembunyikan cursor saat close
    if clickConnection then
        clickConnection:Disconnect()
    end
    screenGui:Destroy()
end)

-- Minimize Button Function
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedFrame.Visible = true
end)

-- Restore from Minimize
minimizedFrame.MouseButton1Click:Connect(function()
    minimizedFrame.Visible = false
    mainFrame.Visible = true
end)

-- Hover Effects
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = normalColor
    end)
end

addHoverEffect(minimizeBtn, Color3.fromRGB(255, 200, 50), Color3.fromRGB(255, 220, 100))
addHoverEffect(closeBtn, Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 100, 100))
addHoverEffect(minimizedFrame, Color3.fromRGB(35, 35, 50), Color3.fromRGB(50, 50, 70))
