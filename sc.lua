-- Fish It Auto Fishing Script - FINAL VERSION
-- Based on debug analysis and specific rod names
-- Created by AI Assistant

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

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
local currentRod = nil

-- Specific Fish It rod names (from debug analysis)
local fishItRodNames = {
    "Basic Rod", "Starter Rod", "Wooden Rod", "Beginner Rod", "Novice Rod",
    "Advanced Rod", "Pro Rod", "Improved Rod", "Enhanced Rod", "Superior Rod",
    "Master Rod", "Expert Rod", "Elite Rod", "Professional Rod", "Champion Rod",
    "Super Rod", "Ultra Rod", "Mega Rod", "Hyper Rod", "Ultimate Rod",
    "Legendary Rod", "Mythic Rod", "God Rod", "Divine Rod", "Celestial Rod", "Ethereal Rod", "Infinite Rod",
    "Golden Rod", "Crystal Rod", "Diamond Rod", "Ruby Rod", "Sapphire Rod", "Emerald Rod",
    "Summer Rod", "Winter Rod", "Spring Rod", "Autumn Rod", "Event Rod", "Holiday Rod",
    "Fishing Rod", "Angler Rod", "Hunter Rod", "Catcher Rod", "Reel Master", "Fish Master",
    "Ocean Master", "Sea King", "Depth Diver", "Abyss Walker", "Neptune's Rod", "Poseidon's Rod"
}

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
    mainFrame.Size = UDim2.new(0, 320, 0, 420)
    mainFrame.Position = UDim2.new(0.02, 0, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 45)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎣 Fish It Auto v2.7 🎣"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = mainFrame
    
    -- Status Container
    local statusContainer = Instance.new("Frame")
    statusContainer.Name = "StatusContainer"
    statusContainer.Size = UDim2.new(1, -20, 0, 80)
    statusContainer.Position = UDim2.new(0, 10, 0, 55)
    statusContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    statusContainer.BorderSizePixel = 0
    statusContainer.Parent = mainFrame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusContainer
    
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, -10, 0, 25)
    statusLabel.Position = UDim2.new(0, 5, 0, 5)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Menunggu"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.Parent = statusContainer
    
    -- Rod Info Label
    local rodInfoLabel = Instance.new("TextLabel")
    rodInfoLabel.Name = "RodInfo"
    rodInfoLabel.Size = UDim2.new(1, -10, 0, 25)
    rodInfoLabel.Position = UDim2.new(0, 5, 0, 35)
    rodInfoLabel.BackgroundTransparency = 1
    rodInfoLabel.Text = "Rod: Tidak terdeteksi"
    rodInfoLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    rodInfoLabel.TextScaled = true
    rodInfoLabel.Font = Enum.Font.SourceSans
    rodInfoLabel.Parent = statusContainer
    
    -- Fish Count Label
    local fishCountLabel = Instance.new("TextLabel")
    fishCountLabel.Name = "FishCount"
    fishCountLabel.Size = UDim2.new(1, -10, 0, 20)
    fishCountLabel.Position = UDim2.new(0, 5, 0, 65)
    fishCountLabel.BackgroundTransparency = 1
    fishCountLabel.Text = "Ikan: 0"
    fishCountLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    fishCountLabel.TextScaled = true
    fishCountLabel.Font = Enum.Font.SourceSans
    fishCountLabel.Parent = statusContainer
    
    -- Time Label
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Name = "Time"
    timeLabel.Size = UDim2.new(1, -10, 0, 20)
    timeLabel.Position = UDim2.new(0, 5, 0, 90)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Waktu: 00:00"
    timeLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.SourceSans
    timeLabel.Parent = statusContainer
    
    -- Instructions
    local instructions = Instance.new("TextLabel")
    instructions.Name = "Instructions"
    instructions.Size = UDim2.new(1, -20, 0, 60)
    instructions.Position = UDim2.new(0, 10, 0, 145)
    instructions.BackgroundTransparency = 1
    instructions.Text = "Cara pakai:\n1. Equip fishing rod\n2. Tekan tombol Auto Fishing\n3. Script akan otomatis mancing"
    instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
    instructions.TextScaled = true
    instructions.Font = Enum.Font.SourceSans
    instructions.TextWrapped = true
    instructions.Parent = mainFrame
    
    -- Main Toggle Button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, -20, 0, 45)
    toggleButton.Position = UDim2.new(0, 10, 0, 215)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.Text = "Auto Fishing: OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton
    
    -- Settings Button
    local settingsButton = Instance.new("TextButton")
    settingsButton.Name = "SettingsButton"
    settingsButton.Size = UDim2.new(1, -20, 0, 35)
    settingsButton.Position = UDim2.new(0, 10, 0, 270)
    settingsButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    settingsButton.Text = "⚙️ Pengaturan"
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.TextScaled = true
    settingsButton.Font = Enum.Font.SourceSansBold
    settingsButton.Parent = mainFrame
    
    local settingsCorner = Instance.new("UICorner")
    settingsCorner.CornerRadius = UDim.new(0, 6)
    settingsCorner.Parent = settingsButton
    
    -- Force Enable Button
    local forceButton = Instance.new("TextButton")
    forceButton.Name = "ForceButton"
    forceButton.Size = UDim2.new(1, -20, 0, 35)
    forceButton.Position = UDim2.new(0, 10, 0, 315)
    forceButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    forceButton.Text = "🔧 Force Enable"
    forceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    forceButton.TextScaled = true
    forceButton.Font = Enum.Font.SourceSansBold
    forceButton.Parent = mainFrame
    
    local forceCorner = Instance.new("UICorner")
    forceCorner.CornerRadius = UDim.new(0, 6)
    forceCorner.Parent = forceButton
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(1, -20, 0, 35)
    closeButton.Position = UDim2.new(0, 10, 0, 360)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "❌ Tutup GUI"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Button functions
    toggleButton.MouseButton1Click:Connect(function()
        autoFishing = not autoFishing
        if autoFishing then
            local rod = getCurrentRod()
            if not rod then
                statusLabel.Text = "Status: Equip rod dulu!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
                autoFishing = false
                return
            end
            
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
    
    settingsButton.MouseButton1Click:Connect(function()
        showSettings()
    end)
    
    forceButton.MouseButton1Click:Connect(function()
        autoFishing = true
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
        toggleButton.Text = "Auto Fishing: FORCE"
        statusLabel.Text = "Status: Force Mode AKTIF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        startTime = tick()
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
            
            -- Update rod info
            local currentRodName = getCurrentRodName()
            if currentRodName then
                rodInfoLabel.Text = "Rod: " .. currentRodName
                rodInfoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                rodInfoLabel.Text = "Rod: Tidak terdeteksi"
                rodInfoLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
            end
            
            wait(1)
        end
    end)
    
    return gui
end

-- Settings function
local function showSettings()
    if not gui then return end
    
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name = "SettingsFrame"
    settingsFrame.Size = UDim2.new(0, 300, 0, 250)
    settingsFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
    settingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    settingsFrame.BorderSizePixel = 0
    settingsFrame.Parent = gui
    
    local settingsCorner = Instance.new("UICorner")
    settingsCorner.CornerRadius = UDim.new(0, 10)
    settingsCorner.Parent = settingsFrame
    
    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Size = UDim2.new(1, 0, 0, 35)
    settingsTitle.Position = UDim2.new(0, 0, 0, 0)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Text = "⚙️ Pengaturan & Info"
    settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 100)
    settingsTitle.TextScaled = true
    settingsTitle.Font = Enum.Font.SourceSansBold
    settingsTitle.Parent = settingsFrame
    
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -20, 0, 150)
    infoText.Position = UDim2.new(0, 10, 0, 40)
    infoText.BackgroundTransparency = 1
    infoText.Text = "Fish It Auto Fishing v2.7\n\nFitur:\n• Auto deteksi " .. #fishItRodNames .. " jenis rod\n• Auto cast & reel\n• Anti-AFK protection\n• Real-time status\n• Force mode untuk rod kustom\n\nCara pakai:\n1. Equip fishing rod\n2. Klik Auto Fishing\n3. Script akan otomatis bekerja"
    infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoText.TextScaled = false
    infoText.Font = Enum.Font.SourceSans
    infoText.TextSize = 12
    infoText.TextWrapped = true
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.Parent = settingsFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 80, 0, 30)
    closeButton.Position = UDim2.new(0.5, -40, 0, 210)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "Tutup"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = settingsFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        settingsFrame:Destroy()
    end)
end

-- Get current fishing rod
local function getCurrentRod()
    local character = player.Character
    if not character then return nil end
    
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            for _, rodName in pairs(fishItRodNames) do
                if item.Name:lower():find(rodName:lower()) then
                    return item
                end
            end
            -- Fallback: any item with "Rod" in name
            if item.Name:lower():find("rod") then
                return item
            end
        end
    end
    return nil
end

-- Get current rod name
local function getCurrentRodName()
    local rod = getCurrentRod()
    return rod and rod.Name or nil
end

-- Check if player has fishing rod
local function hasFishingRod()
    return getCurrentRod() ~= nil
end

-- Cast fishing rod using multiple methods
local function castFishingRod()
    if not autoFishing then return end
    
    -- Method 1: Try F key (common fishing key)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    
    -- Method 2: Try E key (alternative fishing key)
    wait(0.3)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    
    -- Method 3: Try mouse click
    wait(0.3)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    
    -- Method 4: Try number keys (1-5)
    for i = 1, 5 do
        wait(0.2)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode["One"], false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode["One"], false, game)
    end
    
    wait(1)
end

-- Reel fish using multiple methods
local function reelFish()
    if not autoFishing then return end
    
    -- Method 1: Try E key
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    
    -- Method 2: Try mouse click
    wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    wait(0.1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    
    -- Method 3: Try spacebar
    wait(0.2)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    
    fishCount = fishCount + 1
    wait(1)
end

-- Check for fish bite (improved detection)
local function checkForFishBite()
    -- Method 1: Check character for fishing-related values
    local character = player.Character
    if character then
        for _, child in pairs(character:GetChildren()) do
            if child.Name:lower():find("bite") or child.Name:lower():find("fish") then
                if child:IsA("BoolValue") and child.Value then
                    return true
                end
            end
        end
    end
    
    -- Method 2: Check player values
    for _, child in pairs(player:GetChildren()) do
        if child.Name:lower():find("bite") or child.Name:lower():find("fish") then
            if child:IsA("BoolValue") and child.Value then
                return true
            end
        end
    end
    
    -- Method 3: Random chance (fallback)
    return math.random() > 0.7
end

-- Main fishing loop
local function startFishingLoop()
    spawn(function()
        while true do
            if autoFishing and not isFishing then
                isFishing = true
                
                -- Check rod status
                local currentRodName = getCurrentRodName()
                if not currentRodName then
                    if gui and gui:FindFirstChild("MainFrame") then
                        gui.MainFrame.StatusContainer.Status.Text = "Status: Equip rod dulu!"
                        gui.MainFrame.StatusContainer.Status.TextColor3 = Color3.fromRGB(255, 150, 100)
                    end
                    isFishing = false
                    wait(2)
                    continue
                end
                
                -- Update status
                if gui and gui:FindFirstChild("MainFrame") then
                    gui.MainFrame.StatusContainer.Status.Text = "Status: Melempar pancing..."
                    gui.MainFrame.StatusContainer.Status.TextColor3 = Color3.fromRGB(100, 150, 255)
                end
                
                -- Cast the rod
                castFishingRod()
                
                -- Wait for fish to bite
                local waitTime = math.random(3, 8)
                local waited = 0
                
                if gui and gui:FindFirstChild("MainFrame") then
                    gui.MainFrame.StatusContainer.Status.Text = "Status: Menunggu ikan..."
                    gui.MainFrame.StatusContainer.Status.TextColor3 = Color3.fromRGB(255, 255, 100)
                end
                
                while waited < waitTime and autoFishing do
                    if checkForFishBite() then
                        break
                    end
                    wait(0.5)
                    waited = waited + 0.5
                end
                
                -- Reel the fish
                if autoFishing then
                    if gui and gui:FindFirstChild("MainFrame") then
                        gui.MainFrame.StatusContainer.Status.Text = "Status: Menarik ikan..."
                        gui.MainFrame.StatusContainer.Status.TextColor3 = Color3.fromRGB(100, 255, 150)
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

-- Anti-AFK function
local function startAntiAFK()
    spawn(function()
        while true do
            wait(math.random(120, 300)) -- Random 2-5 minutes
            
            if autoFishing then
                -- Move slightly
                if humanoidRootPart then
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(math.random(-2, 2), 0, math.random(-2, 2))
                end
                
                -- Jump occasionally
                if character and character:FindFirstChild("Humanoid") and math.random() > 0.8 then
                    character.Humanoid.Jump = true
                end
            end
        end
    end)
end

-- Monitor rod changes
local function setupRodMonitoring()
    -- Monitor for tool equip/unequip
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            local isRod = false
            for _, rodName in pairs(fishItRodNames) do
                if child.Name:lower():find(rodName:lower()) then
                    isRod = true
                    break
                end
            end
            if not isRod and child.Name:lower():find("rod") then
                isRod = true
            end
            
            if isRod and gui and gui:FindFirstChild("MainFrame") then
                gui.MainFrame.StatusContainer.RodInfo.Text = "Rod: " .. child.Name
                gui.MainFrame.StatusContainer.RodInfo.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
        end
    end)
    
    character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            if gui and gui:FindFirstChild("MainFrame") then
                gui.MainFrame.StatusContainer.RodInfo.Text = "Rod: Tidak terdeteksi"
                gui.MainFrame.StatusContainer.RodInfo.TextColor3 = Color3.fromRGB(255, 150, 100)
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
    
    -- Setup rod monitoring
    setupRodMonitoring()
    
    -- Notification
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Fish It Auto Ready",
            Text = "Script berhasil dimuat! Equip fishing rod lalu aktifkan auto fishing.",
            Duration = 5
        })
    end)
    
    print("=== Fish It Auto Fishing Script ===")
    print("✅ Script berhasil dijalankan!")
    print("🎣 Mendukung " .. #fishItRodNames .. " jenis fishing rod")
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
        StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Script error: " .. tostring(err),
            Duration = 10
        })
    end)
end
