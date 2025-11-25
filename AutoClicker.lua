local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Membersihkan GUI lama jika ada (agar tidak menumpuk saat di-execute ulang)
local screenGuiName = "SimpleAutoClickerGUI"
if game.CoreGui:FindFirstChild(screenGuiName) then
    game.CoreGui[screenGuiName]:Destroy()
elseif LocalPlayer.PlayerGui:FindFirstChild(screenGuiName) then
    LocalPlayer.PlayerGui[screenGuiName]:Destroy()
end

-- 2. Membuat GUI Dasar
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

-- Konfigurasi Properti GUI
ScreenGui.Name = screenGuiName
-- Mencoba memasukkan ke CoreGui (lebih aman dari reset), jika gagal ke PlayerGui
pcall(function()
    ScreenGui.Parent = game.CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

-- Main Frame (Kotak Utama)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75) -- Posisi tengah
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Membuat menu bisa digeser mouse

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Judul
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Auto Clicker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Tombol ON/OFF
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60) -- Merah (Mati)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleButton

-- Status Label (Instruksi)
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(1, 0, 0.2, 0)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Tekan tombol untuk mulai"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 10

-- 3. Logika Auto Clicker
local autoClickEnabled = false

-- Fungsi Klik
local function doClick()
    -- VirtualUser adalah cara paling umum meniru klik mouse di script internal
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new())
end

-- Loop utama (Berjalan setiap frame render jika aktif)
RunService.RenderStepped:Connect(function()
    if autoClickEnabled then
        doClick()
    end
end)

-- Event saat tombol ditekan
ToggleButton.MouseButton1Click:Connect(function()
    autoClickEnabled = not autoClickEnabled
    
    if autoClickEnabled then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Hijau
        StatusLabel.Text = "Sedang mengklik..."
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60) -- Merah
        StatusLabel.Text = "Berhenti"
    end
end)
