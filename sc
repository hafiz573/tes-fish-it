-- Fish It Auto Fishing Script - WORKING VERSION
-- Created by AI Assistant
-- Features: Auto Fishing, GUI, Error Handling

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local autoFishing = false
local fishCount = 0
local startTime = tick()
local gui = nil
local isFishing = false

-- GUI Creation
local function createGUI()
    -- Destroy existing GUI
    if gui then
        gui:Destroy()
    end
    
    gui = Instance.new("ScreenGui")
    gui.Name = "FishItAutoGUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 280, 0, 320)
    mainFrame.Position = UDim2.new(0.02, 0, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎣 Fish It Auto v2.7 🎣"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.Bold
    title.Parent = mainFrame
    
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, -10, 0, 25)
    statusLabel.Position = UDim2.new(0, 5, 0, 45)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Menunggu"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = mainFrame
    
    -- Fish Count
    local fishCountLabel = Instance.new("TextLabel")
    fishCountLabel.Name = "FishCount"
    fishCountLabel.Size = UDim2.new(1, -10, 0, 20)
    fishCountLabel.Position = UDim2.new(0, 5, 0, 75)
    fishCountLabel.BackgroundTransparency = 1
    fishCountLabel.Text = "Ikan: 0"
    fishCountLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    fishCountLabel.TextScaled = true
    fishCountLabel.Font = Enum.Font.SourceSans
    fishCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    fishCountLabel.Parent = mainFrame
    
    -- Time Label
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Name = "Time"
    timeLabel.Size = UDim2.new(1, -10, 0, 20)
    timeLabel.Position = UDim2.new(0, 5, 0, 100)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Waktu: 00:00"
    timeLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.SourceSans
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    timeLabel.Parent = mainFrame
    
    -- Instructions
    local instructions = Instance.new("TextLabel")
    instructions.Name = "Instructions"
    instructions.Size = UDim2.new(1, -10, 0, 60)
    instructions.Position = UDim2.new(0, 5, 0, 130)
    instructions.BackgroundTransparency = 1
    instructions.Text = "Cara pakai:\n1. Equip fishing rod\n2. Tekan tombol Auto Fishing\n3. Script akan otomatis mancing"
    instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
    instructions.TextScaled = true
    instructions.Font = Enum.Font.SourceSans
    instructions.TextXAlignment = Enum.TextXAlignment.Left
    instructions.TextWrapped = true
    instructions.Parent = mainFrame
    
    -- Toggle Button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, -20, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 200)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.Text = "Auto Fishing: OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.Parent = mainFrame
    
    -- Button Corner
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = toggleButton
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(1, -20, 0, 30)
    closeButton.Position = UDim2.new(0, 10, 0, 250)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "❌ Tutup GUI"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = mainFrame
    
    -- Close Button Corner
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    -- Button functions
    toggleButton.MouseButton1Click:Connect(function()
        autoFishing = not autoFishing
        if autoFishing then
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            toggleButton.Text = "Auto Fishing: ON"
            statusLabel.Text = "Status: Auto Fishing AKTIF"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            startTime = tick()
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            toggleButton.Text = "Auto Fishing: OFF"
            statusLabel.Text = "Status: Berhenti"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            isFishing = false
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
        gui = nil
        autoFishing = false
        isFishing = false
    end)
    
    -- Update loop
    spawn(function()
        while gui and gui.Parent do
            if autoFishing then
                local elapsed = math.floor(tick() - startTime)
                local minutes = math.floor(elapsed / 60)
                local seconds = elapsed % 60
                timeLabel.Text = string.format("Waktu: %02d:%02d", minutes, seconds)
            end
            fishCountLabel.Text = string.format("Ikan: %d", fishCount)
            wait(1)
        end
    end)
    
    return gui
end

-- Simple fishing function using key press
local function castFishingRod()
    if not autoFishing then return end
    
    -- Method 1: Try using F key (common fishing key)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    
    -- Method 2: Try using E key (alternative fishing key)
    wait(0.5)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    
    wait(1)
end

local function reelFish()
    if not autoFishing then return end
    
    -- Try to reel fish using common keys
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    
    -- Alternative: Try mouse click
    wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    
    fishCount = fishCount + 1
    wait(1)
end

-- Check if player has fishing rod equipped
local function hasFishingRod()
    local character = player.Character
    if not character then return false end
    
    -- Check for fishing rod in character
    for _, item in pairs(character:GetChildren()) do
        if item.Name:find("Rod") or item.Name:find("Fishing") then
            return true
        end
    end
    
    -- Check backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:find("Rod") or item.Name:find("Fishing") then
                return true
            end
        end
    end
    
    return false
end

-- Main fishing loop
local function startFishingLoop()
    spawn(function()
        while true do
            if autoFishing and not isFishing then
                isFishing = true
                
                -- Check if player has fishing rod
                if not hasFishingRod() then
                    if gui and gui:FindFirstChild("MainFrame") then
                        gui.MainFrame.Status.Text = "Status: Equip fishing rod dulu!"
                        gui.MainFrame.Status.TextColor3 = Color3.fromRGB(255, 150, 50)
                    end
                    isFishing = false
                    wait(2)
                    continue
                end
                
                -- Cast the rod
                if gui and gui:FindFirstChild("MainFrame") then
                    gui.MainFrame.Status.Text = "Status: Melempar pancing..."
                    gui.MainFrame.Status.TextColor3 = Color3.fromRGB(100, 150, 255)
                end
                
                castFishingRod()
                
                -- Wait for fish to bite (random time between 3-8 seconds)
                local waitTime = math.random(3, 8)
                local waited = 0
                
                if gui and gui:FindFirstChild("MainFrame") then
                    gui.MainFrame.Status.Text = "Status: Menunggu ikan..."
                    gui.MainFrame.Status.TextColor3 = Color3.fromRGB(255, 255, 100)
                end
                
                while waited < waitTime and autoFishing do
                    wait(0.5)
                    waited = waited + 0.5
                end
                
                -- Reel the fish
                if autoFishing then
                    if gui and gui:FindFirstChild("MainFrame") then
                        gui.MainFrame.Status.Text = "Status: Menarik ikan..."
                        gui.MainFrame.Status.TextColor3 = Color3.fromRGB(100, 255, 150)
                    end
                    
                    reelFish()
                end
                
                -- Small delay before next cast
                wait(2)
                isFishing = false
            else
                wait(0.5)
            end
        end
    end)
end

-- Simple anti-AFK
local function startAntiAFK()
    spawn(function()
        while true do
            wait(math.random(120, 300)) -- Random 2-5 minutes
            
            if autoFishing then
                -- Move slightly
                humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(math.random(-2, 2), 0, math.random(-2, 2))
                
                -- Jump occasionally
                if math.random() > 0.8 then
                    humanoidRootPart.Parent.Humanoid.Jump = true
                end
            end
        end
    end)
end

-- Initialize
local function initialize()
    -- Create GUI
    createGUI()
    
    -- Start fishing loop
    startFishingLoop()
    
    -- Start anti-AFK
    startAntiAFK()
    
    -- Notification
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Fish It Auto",
            Text = "Script berhasil dimuat! Equip fishing rod lalu aktifkan auto fishing.",
            Duration = 5
        })
    end)
    
    print("=== Fish It Auto Fishing Script ===")
    print("✅ Script berhasil dijalankan!")
    print("🎮 Equip fishing rod Anda terlebih dahulu")
    print("🔧 Gunakan GUI untuk mengontrol auto fishing")
    print("====================================")
end

-- Error handling
local success, err = pcall(function()
    initialize()
end)

if not success then
    warn("Error menjalankan script: " .. tostring(err))
    
    -- Try to show error message
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Script error: " .. tostring(err),
            Duration = 10
        })
    end)
end
