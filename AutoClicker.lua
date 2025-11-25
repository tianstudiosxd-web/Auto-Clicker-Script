local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Variabel Status
local autoClickerEnabled = false
local clickSpeed = 1
local isRunning = true
local clickConnection
local clickPosition = Vector2.new(0, 0)

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

-- ================ DRAGGABLE CURSOR ICON ================
local cursorFrame = Instance.new("Frame")
cursorFrame.Name = "CursorFrame"
cursorFrame.Size = UDim2.new(0, 50, 0, 50)
cursorFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
cursorFrame.BackgroundTransparency = 1
cursorFrame.Visible = false
cursorFrame.ZIndex = 10
cursorFrame.Parent = screenGui

-- Cursor Icon (Bentuk Kursor)
local cursorIcon = Instance.new("ImageLabel")
cursorIcon.Name = "CursorIcon"
cursorIcon.Size = UDim2.new(0, 32, 0, 32)
cursorIcon.Position = UDim2.new(0.5, -16, 0.5, -16)
cursorIcon.BackgroundTransparency = 1
cursorIcon.Image = "rbxassetid://2833720882" -- Icon cursor default Roblox
cursorIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
cursorIcon.ZIndex = 11
cursorIcon.Parent = cursorFrame

-- Glow Effect untuk Cursor
local cursorGlow = Instance.new("ImageLabel")
cursorGlow.Name = "Glow"
cursorGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
cursorGlow.Position = UDim2.new(-0.25, 0, -0.25, 0)
cursorGlow.BackgroundTransparency = 1
cursorGlow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
cursorGlow.ImageColor3 = Color3.fromRGB(80, 255, 120)
cursorGlow.ImageTransparency = 0.5
cursorGlow.ZIndex = 10
cursorGlow.Parent = cursorFrame

-- Animasi Glow Pulsing
local glowTween = TweenService:Create(cursorGlow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    ImageTransparency = 0.8,
    Size = UDim2.new(2, 0, 2, 0),
    Position = UDim2.new(-0.5, 0, -0.5, 0)
})

-- Click Indicator
local clickIndicator = Instance.new("Frame")
clickIndicator.Name = "ClickIndicator"
clickIndicator.Size = UDim2.new(0, 10, 0, 10)
clickIndicator.Position = UDim2.new(0.5, -5, 0.5, -5)
clickIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
clickIndicator.BackgroundTransparency = 1
clickIndicator.ZIndex = 12
clickIndicator.Parent = cursorFrame

local clickCorner = Instance.new("UICorner")
clickCorner.CornerRadius = UDim.new(1, 0)
clickCorner.Parent = clickIndicator

-- Dragging Functionality untuk Main Frame
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

-- Dragging Functionality untuk Cursor
local cursorDragging, cursorDragInput, cursorDragStart, cursorStartPos

local function updateCursorDrag(input)
    local delta = input.Position - cursorDragStart
    local newPos = UDim2.new(
        cursorStartPos.X.Scale, 
        cursorStartPos.X.Offset + delta.X, 
        cursorStartPos.Y.Scale, 
        cursorStartPos.Y.Offset + delta.Y
    )
    cursorFrame.Position = newPos
    
    -- Update click position
    local absPos = cursorFrame.AbsolutePosition
    local absSize = cursorFrame.AbsoluteSize
    clickPosition = Vector2.new(absPos.X + absSize.X/2, absPos.Y + absSize.Y/2)
end

cursorFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        cursorDragging = true
        cursorDragStart = input.Position
        cursorStartPos = cursorFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                cursorDragging = false
            end
        end)
    end
end)

cursorFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        cursorDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == cursorDragInput and cursorDragging then
        updateCursorDrag(input)
    end
end)

-- Fungsi untuk show click effect
local function showClickEffect()
    clickIndicator.BackgroundTransparency = 0
    clickIndicator.Size = UDim2.new(0, 10, 0, 10)
    clickIndicator.Position = UDim2.new(0.5, -5, 0.5, -5)
    
    local clickTween = TweenService:Create(clickIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.5, -15, 0.5, -15)
    })
    clickTween:Play()
end

-- Fungsi Auto Clicker yang lebih baik
local function performClick()
    -- Update posisi klik
    local absPos = cursorFrame.AbsolutePosition
    local absSize = cursorFrame.AbsoluteSize
    clickPosition = Vector2.new(absPos.X + absSize.X/2, absPos.Y + absSize.Y/2)
    
    -- Simulasi klik menggunakan VirtualInputManager
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, true, game, 0)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, false, game, 0)
    end)
    
    -- Jika VirtualInputManager tidak tersedia, gunakan mouse1click
    if not pcall(function() return VirtualInputManager end) then
        mouse1click()
    end
    
    -- Show visual feedback
    showClickEffect()
end

local function startAutoClicker()
    if clickConnection then
        clickConnection:Disconnect()
    end
    
    local delay = 1 / clickSpeed
    
    clickConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if autoClickerEnabled and isRunning then
            performClick()
            task.wait(delay)
        end
    end)
end

-- Toggle Button Function
toggleBtn.MouseButton1Click:Connect(function()
    local speedValue = tonumber(speedInput.Text)
    
    if not speedValue then
        statusLabel.Text = "Status: Invalid Input!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
        task.wait(2)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    if speedValue > 1000 then
        statusLabel.Text = "Status: Max 1000!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
        task.wait(2)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    if speedValue < 1 then
        statusLabel.Text = "Status: Min 1!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
        task.wait(2)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    autoClickerEnabled = not autoClickerEnabled
    clickSpeed = speedValue
    
    if autoClickerEnabled then
        -- Tampilkan cursor
        cursorFrame.Visible = true
        glowTween:Play()
        
        -- Update UI
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
        statusLabel.Text = "Status: ON (" .. clickSpeed .. " CPS)"
        statusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
        
        -- Update posisi klik awal
        local absPos = cursorFrame.AbsolutePosition
        local absSize = cursorFrame.AbsoluteSize
        clickPosition = Vector2.new(absPos.X + absSize.X/2, absPos.Y + absSize.Y/2)
        
        -- Mulai auto clicker
        startAutoClicker()
    else
        -- Sembunyikan cursor
        cursorFrame.Visible = false
        glowTween:Cancel()
        
        -- Update UI
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        
        -- Stop auto clicker
        if clickConnection then
            clickConnection:Disconnect()
        end
    end
end)

-- Close Button Function
closeBtn.MouseButton1Click:Connect(function()
    isRunning = false
    autoClickerEnabled = false
    glowTween:Cancel()
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
