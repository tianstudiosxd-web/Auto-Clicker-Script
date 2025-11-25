local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variabel Global
local autoClickerEnabled = false
local clickSpeed = 1
local clickPosition = nil
local clickConnection = nil
local cursorGui = nil

-- Fungsi untuk membuat GUI
local function createGUI()
    -- ScreenGui Utama
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoClickerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Frame Utama (240x180)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 240, 0, 180)
    mainFrame.Position = UDim2.new(0.5, -120, 0.5, -90)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    -- Corner untuk rounded edges
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Auto Clicker"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- Close Button (X)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 2.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton

    -- Minimize Button (-) di sebelah Close
    local minimizeHeaderButton = Instance.new("TextButton")
    minimizeHeaderButton.Name = "MinimizeHeaderButton"
    minimizeHeaderButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeHeaderButton.Position = UDim2.new(1, -60, 0, 2.5)
    minimizeHeaderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
    minimizeHeaderButton.Text = "-"
    minimizeHeaderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeHeaderButton.TextSize = 20
    minimizeHeaderButton.Font = Enum.Font.GothamBold
    minimizeHeaderButton.BorderSizePixel = 0
    minimizeHeaderButton.Parent = header

    local minimizeHeaderCorner = Instance.new("UICorner")
    minimizeHeaderCorner.CornerRadius = UDim.new(0, 6)
    minimizeHeaderCorner.Parent = minimizeHeaderButton

    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -40)
    contentFrame.Position = UDim2.new(0, 10, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Speed Label
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, 0, 0, 25)
    speedLabel.Position = UDim2.new(0, 0, 0, 10)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Kecepatan (detik):"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 14
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = contentFrame

    -- Speed Input
    local speedInput = Instance.new("TextBox")
    speedInput.Name = "SpeedInput"
    speedInput.Size = UDim2.new(1, 0, 0, 30)
    speedInput.Position = UDim2.new(0, 0, 0, 40)
    speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    speedInput.BorderSizePixel = 0
    speedInput.Text = "1"
    speedInput.PlaceholderText = "Masukkan kecepatan..."
    speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    speedInput.TextSize = 14
    speedInput.Font = Enum.Font.Gotham
    speedInput.ClearTextOnFocus = false
    speedInput.Parent = contentFrame

    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 6)
    speedCorner.Parent = speedInput

    -- Confirm Button
    local confirmButton = Instance.new("TextButton")
    confirmButton.Name = "ConfirmButton"
    confirmButton.Size = UDim2.new(1, 0, 0, 30)
    confirmButton.Position = UDim2.new(0, 0, 0, 80)
    confirmButton.BackgroundColor3 = Color3.fromRGB(70, 130, 220)
    confirmButton.Text = "Confirm"
    confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmButton.TextSize = 14
    confirmButton.Font = Enum.Font.GothamBold
    confirmButton.BorderSizePixel = 0
    confirmButton.Parent = contentFrame

    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 6)
    confirmCorner.Parent = confirmButton

    -- Toggle Button (On/Off)
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, 0, 0, 30)
    toggleButton.Position = UDim2.new(0, 0, 0, 115)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
    toggleButton.Text = "On"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 14
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = contentFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton

    return screenGui, mainFrame, closeButton, minimizeHeaderButton, speedInput, confirmButton, toggleButton
end

-- Fungsi untuk membuat minimize button floating dengan RGB kelap-kelip di setiap sudut
local function createFloatingButton()
    local floatingGui = Instance.new("ScreenGui")
    floatingGui.Name = "FloatingMinimize"
    floatingGui.ResetOnSpawn = false
    floatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    floatingGui.Parent = playerGui

    -- Frame utama button (kotak dengan sudut tidak lancip)
    local floatingButton = Instance.new("TextButton")
    floatingButton.Size = UDim2.new(0, 50, 0, 50)
    floatingButton.Position = UDim2.new(0, 20, 0.5, -25)
    floatingButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    floatingButton.Text = "AC"
    floatingButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    floatingButton.TextSize = 18
    floatingButton.Font = Enum.Font.GothamBold
    floatingButton.BorderSizePixel = 0
    floatingButton.Active = true
    floatingButton.Draggable = true
    floatingButton.Parent = floatingGui

    -- Corner radius kecil agar sudutnya tidak lancip tapi masih berbentuk kotak
    local floatingCorner = Instance.new("UICorner")
    floatingCorner.CornerRadius = UDim.new(0, 5)
    floatingCorner.Parent = floatingButton

    -- Membuat 4 frame kecil di setiap sudut untuk efek RGB kelap-kelip
    local cornerSize = 8
    local corners = {}

    -- Sudut Kiri Atas
    local topLeft = Instance.new("Frame")
    topLeft.Size = UDim2.new(0, cornerSize, 0, cornerSize)
    topLeft.Position = UDim2.new(0, -2, 0, -2)
    topLeft.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    topLeft.BorderSizePixel = 0
    topLeft.ZIndex = 2
    topLeft.Parent = floatingButton
    table.insert(corners, topLeft)

    local topLeftCorner = Instance.new("UICorner")
    topLeftCorner.CornerRadius = UDim.new(1, 0)
    topLeftCorner.Parent = topLeft

    -- Sudut Kanan Atas
    local topRight = Instance.new("Frame")
    topRight.Size = UDim2.new(0, cornerSize, 0, cornerSize)
    topRight.Position = UDim2.new(1, -6, 0, -2)
    topRight.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    topRight.BorderSizePixel = 0
    topRight.ZIndex = 2
    topRight.Parent = floatingButton
    table.insert(corners, topRight)

    local topRightCorner = Instance.new("UICorner")
    topRightCorner.CornerRadius = UDim.new(1, 0)
    topRightCorner.Parent = topRight

    -- Sudut Kiri Bawah
    local bottomLeft = Instance.new("Frame")
    bottomLeft.Size = UDim2.new(0, cornerSize, 0, cornerSize)
    bottomLeft.Position = UDim2.new(0, -2, 1, -6)
    bottomLeft.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    bottomLeft.BorderSizePixel = 0
    bottomLeft.ZIndex = 2
    bottomLeft.Parent = floatingButton
    table.insert(corners, bottomLeft)

    local bottomLeftCorner = Instance.new("UICorner")
    bottomLeftCorner.CornerRadius = UDim.new(1, 0)
    bottomLeftCorner.Parent = bottomLeft

    -- Sudut Kanan Bawah
    local bottomRight = Instance.new("Frame")
    bottomRight.Size = UDim2.new(0, cornerSize, 0, cornerSize)
    bottomRight.Position = UDim2.new(1, -6, 1, -6)
    bottomRight.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    bottomRight.BorderSizePixel = 0
    bottomRight.ZIndex = 2
    bottomRight.Parent = floatingButton
    table.insert(corners, bottomRight)

    local bottomRightCorner = Instance.new("UICorner")
    bottomRightCorner.CornerRadius = UDim.new(1, 0)
    bottomRightCorner.Parent = bottomRight

    -- Animasi RGB Kelap-Kelip untuk setiap sudut
    spawn(function()
        local hue = 0
        local blinkState = true
        local blinkSpeed = 0
        
        while floatingButton.Parent do
            hue = (hue + 0.02) % 1
            blinkSpeed = (blinkSpeed + 0.1) % (math.pi * 2)
            
            -- Efek kelap-kelip menggunakan sine wave
            local brightness = (math.sin(blinkSpeed) + 1) / 2
            
            for i, corner in ipairs(corners) do
                -- Setiap sudut memiliki offset hue berbeda untuk efek rainbow
                local cornerHue = (hue + (i - 1) * 0.25) % 1
                local color = Color3.fromHSV(cornerHue, 1, brightness)
                corner.BackgroundColor3 = color
            end
            
            wait(0.03)
        end
    end)

    return floatingGui, floatingButton
end

-- Fungsi untuk membuat cursor crosshair
local function createCursor()
    local cursorScreenGui = Instance.new("ScreenGui")
    cursorScreenGui.Name = "CursorGUI"
    cursorScreenGui.ResetOnSpawn = false
    cursorScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    cursorScreenGui.Parent = playerGui

    local cursorFrame = Instance.new("Frame")
    cursorFrame.Name = "Cursor"
    cursorFrame.Size = UDim2.new(0, 30, 0, 30)
    cursorFrame.Position = UDim2.new(0.5, -15, 0.5, -15)
    cursorFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    cursorFrame.BackgroundTransparency = 0.5
    cursorFrame.BorderSizePixel = 0
    cursorFrame.Active = true
    cursorFrame.Draggable = true
    cursorFrame.Parent = cursorScreenGui

    local cursorCorner = Instance.new("UICorner")
    cursorCorner.CornerRadius = UDim.new(1, 0)
    cursorCorner.Parent = cursorFrame

    -- Crosshair lines
    local horizontalLine = Instance.new("Frame")
    horizontalLine.Size = UDim2.new(1, 10, 0, 2)
    horizontalLine.Position = UDim2.new(0, -5, 0.5, -1)
    horizontalLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    horizontalLine.BorderSizePixel = 0
    horizontalLine.Parent = cursorFrame

    local verticalLine = Instance.new("Frame")
    verticalLine.Size = UDim2.new(0, 2, 1, 10)
    verticalLine.Position = UDim2.new(0.5, -1, 0, -5)
    verticalLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    verticalLine.BorderSizePixel = 0
    verticalLine.Parent = cursorFrame

    return cursorScreenGui
end

-- Fungsi auto click
local function startAutoClicker()
    if clickConnection then
        clickConnection:Disconnect()
    end

    clickConnection = RunService.Heartbeat:Connect(function()
        if autoClickerEnabled and clickPosition then
            wait(clickSpeed)
            
            -- Simulasi click di posisi yang ditentukan
            local virtualInput = {
                Position = clickPosition,
                UserInputType = Enum.UserInputType.MouseButton1
            }
            
            -- Trigger click menggunakan mouse1click jika ada target
            if game:GetService("VirtualUser") then
                game:GetService("VirtualUser"):ClickButton1(clickPosition)
            end
        end
    end)
end

-- Fungsi untuk stop auto clicker
local function stopAutoClicker()
    if clickConnection then
        clickConnection:Disconnect()
        clickConnection = nil
    end
    
    if cursorGui then
        cursorGui:Destroy()
        cursorGui = nil
    end
    
    autoClickerEnabled = false
    clickPosition = nil
end

-- Main Script
local screenGui, mainFrame, closeButton, minimizeHeaderButton, speedInput, confirmButton, toggleButton = createGUI()
local floatingGui, floatingButton = createFloatingButton()
floatingGui.Enabled = false

-- Close Button Function
closeButton.MouseButton1Click:Connect(function()
    stopAutoClicker()
    screenGui:Destroy()
    if floatingGui then
        floatingGui:Destroy()
    end
end)

-- Minimize Header Button Function (-) - Minimize menu menjadi button kotak RGB
minimizeHeaderButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingGui.Enabled = true
end)

-- Floating Button Function - Buka kembali menu utama
floatingButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingGui.Enabled = false
end)

-- Confirm Button Function
confirmButton.MouseButton1Click:Connect(function()
    local speed = tonumber(speedInput.Text)
    if speed and speed > 0 then
        clickSpeed = speed
        
        -- Visual feedback
        confirmButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        wait(0.2)
        confirmButton.BackgroundColor3 = Color3.fromRGB(70, 130, 220)
    else
        -- Error feedback
        confirmButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        wait(0.2)
        confirmButton.BackgroundColor3 = Color3.fromRGB(70, 130, 220)
        speedInput.Text = tostring(clickSpeed)
    end
end)

-- Toggle Button Function
toggleButton.MouseButton1Click:Connect(function()
    autoClickerEnabled = not autoClickerEnabled
    
    if autoClickerEnabled then
        toggleButton.Text = "Off"
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        
        -- Buat cursor untuk memilih posisi
        cursorGui = createCursor()
        local cursor = cursorGui:FindFirstChild("Cursor", true)
        
        -- Update posisi click berdasarkan cursor
        cursor:GetPropertyChangedSignal("Position"):Connect(function()
            clickPosition = Vector2.new(
                cursor.AbsolutePosition.X + cursor.AbsoluteSize.X / 2,
                cursor.AbsolutePosition.Y + cursor.AbsoluteSize.Y / 2
            )
        end)
        
        -- Set posisi awal
        clickPosition = Vector2.new(
            cursor.AbsolutePosition.X + cursor.AbsoluteSize.X / 2,
            cursor.AbsolutePosition.Y + cursor.AbsoluteSize.Y / 2
        )
        
        startAutoClicker()
    else
        toggleButton.Text = "On"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
        stopAutoClicker()
    end
end)

-- Hover effects
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = normalColor
    end)
end

addHoverEffect(closeButton, Color3.fromRGB(220, 50, 50), Color3.fromRGB(255, 70, 70))
addHoverEffect(minimizeHeaderButton, Color3.fromRGB(100, 100, 110), Color3.fromRGB(120, 120, 130))
addHoverEffect(confirmButton, Color3.fromRGB(70, 130, 220), Color3.fromRGB(90, 150, 240))
