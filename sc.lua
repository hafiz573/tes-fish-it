-- Fish It Super Debug Script - Comprehensive Detection
-- Created by AI Assistant
-- Will search for fishing rods in ALL possible locations

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local debugGui = nil
local debugLines = {}
local maxLines = 2000

-- Create comprehensive debug GUI
local function createSuperDebugGUI()
    if debugGui then debugGui:Destroy() end
    
    debugGui = Instance.new("ScreenGui")
    debugGui.Name = "FishItSuperDebugGUI"
    debugGui.ResetOnSpawn = false
    debugGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 700)
    mainFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = debugGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔍 FISH IT SUPER DEBUG 🔍"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = mainFrame
    
    -- Buttons
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -10, 0, 35)
    buttonContainer.Position = UDim2.new(0, 5, 0, 45)
    buttonContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    buttonContainer.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = buttonContainer
    
    -- Scan All Button
    local scanButton = Instance.new("TextButton")
    scanButton.Name = "ScanButton"
    scanButton.Size = UDim2.new(0, 100, 1, -10)
    scanButton.Position = UDim2.new(0, 5, 0, 5)
    scanButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    scanButton.Text = "🔍 Scan All"
    scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    scanButton.Font = Enum.Font.SourceSansBold
    scanButton.TextSize = 12
    scanButton.Parent = buttonContainer
    
    -- Copy Button
    local copyButton = Instance.new("TextButton")
    copyButton.Name = "CopyButton"
    copyButton.Size = UDim2.new(0, 80, 1, -10)
    copyButton.Position = UDim2.new(0, 115, 0, 5)
    copyButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    copyButton.Text = "📋 Copy"
    copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyButton.Font = Enum.Font.SourceSansBold
    copyButton.TextSize = 12
    copyButton.Parent = buttonContainer
    
    -- Clear Button
    local clearButton = Instance.new("TextButton")
    clearButton.Name = "ClearButton"
    clearButton.Size = UDim2.new(0, 80, 1, -10)
    clearButton.Position = UDim2.new(0, 205, 0, 5)
    clearButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    clearButton.Text = "🗑️ Clear"
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.Font = Enum.Font.SourceSansBold
    clearButton.TextSize = 12
    clearButton.Parent = buttonContainer
    
    -- Find Rod Button
    local findRodButton = Instance.new("TextButton")
    findRodButton.Name = "FindRodButton"
    findRodButton.Size = UDim2.new(0, 100, 1, -10)
    findRodButton.Position = UDim2.new(0, 295, 0, 5)
    findRodButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    findRodButton.Text = "🎣 Find Rod"
    findRodButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    findRodButton.Font = Enum.Font.SourceSansBold
    findRodButton.TextSize = 12
    findRodButton.Parent = buttonContainer
    
    -- Scrolling Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -10, 1, -90)
    scrollFrame.Position = UDim2.new(0, 5, 0, 85)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 10
    scrollFrame.Parent = mainFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.Position = UDim2.new(0, 0, 0, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    contentFrame.Parent = scrollFrame
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Function to add debug text
    local function addDebugText(text, color)
        local timestamp = os.date("%H:%M:%S")
        local fullText = "[" .. timestamp .. "] " .. text
        
        table.insert(debugLines, {
            text = fullText,
            color = color or Color3.fromRGB(255, 255, 255),
            timestamp = tick()
        })
        
        if #debugLines > maxLines then
            table.remove(debugLines, 1)
        end
        
        local label = Instance.new("TextLabel")
        label.Name = "DebugLine_" .. #debugLines
        label.Size = UDim2.new(1, -10, 0, 18)
        label.Position = UDim2.new(0, 5, 0, (#debugLines - 1) * 20)
        label.BackgroundTransparency = 1
        label.Text = fullText
        label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        label.TextScaled = false
        label.Font = Enum.Font.Code
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Top
        label.TextWrapped = true
        label.Parent = contentFrame
        
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #debugLines * 20)
        scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.CanvasSize.Y.Offset)
        
        return label
    end
    
    -- Button functions
    scanButton.MouseButton1Click:Connect(function()
        comprehensiveScan()
    end)
    
    copyButton.MouseButton1Click:Connect(function()
        local allText = "FISH IT SUPER DEBUG LOG\n"
        allText = allText .. "Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
        allText = allText .. "Player: " .. player.Name .. " (ID: " .. player.UserId .. ")\n"
        allText = allText .. "========================================\n\n"
        
        for _, line in pairs(debugLines) do
            allText = allText .. line.text .. "\n"
        end
        
        addDebugText("📋 Debug log copied!", Color3.fromRGB(100, 255, 100))
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        for _, child in pairs(contentFrame:GetChildren()) do
            child:Destroy()
        end
        debugLines = {}
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        addDebugText("🗑️ Debug cleared!", Color3.fromRGB(255, 150, 100))
    end)
    
    findRodButton.MouseButton1Click:Connect(function()
        findFishingRod()
    end)
    
    return {
        AddText = addDebugText,
        GUI = debugGui
    }
end

-- Initialize debug
local debug = createSuperDebugGUI()

-- Comprehensive scan function
local function comprehensiveScan()
    debug.AddText("🔍 STARTING COMPREHENSIVE SCAN", Color3.fromRGB(255, 255, 100))
    debug.AddText("=====================================", Color3.fromRGB(255, 255, 100))
    
    -- 1. Scan Player
    debug.AddText("📊 SCANNING PLAYER STRUCTURE", Color3.fromRGB(100, 200, 255))
    debug.AddText("Player Name: " .. player.Name, Color3.fromRGB(255, 255, 255))
    debug.AddText("Player ID: " .. player.UserId, Color3.fromRGB(255, 255, 255))
    
    -- Scan all player children
    debug.AddText("Player Children:", Color3.fromRGB(200, 200, 255))
    for _, child in pairs(player:GetChildren()) do
        debug.AddText("  → " .. child.Name .. " (" .. child.ClassName .. ")", Color3.fromRGB(255, 255, 200))
    end
    
    -- 2. Scan Character
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    debug.AddText("🦴 SCANNING CHARACTER", Color3.fromRGB(100, 200, 255))
    
    if character then
        debug.AddText("Character found!", Color3.fromRGB(100, 255, 100))
        debug.AddText("Character Children:", Color3.fromRGB(200, 200, 255))
        
        for _, child in pairs(character:GetChildren()) do
            debug.AddText("  → " .. child.Name .. " (" .. child.ClassName .. ")", Color3.fromRGB(255, 255, 200))
            
            -- If it's a model or tool, scan deeper
            if child:IsA("Model") or child:IsA("Tool") or child:IsA("Accessory") then
                debug.AddText("    └─ Children of " .. child.Name .. ":", Color3.fromRGB(150, 150, 255))
                for _, subChild in pairs(child:GetChildren()) do
                    debug.AddText("      → " .. subChild.Name .. " (" .. subChild.ClassName .. ")", Color3.fromRGB(200, 200, 255))
                end
            end
        end
    else
        debug.AddText("❌ Character not found!", Color3.fromRGB(255, 100, 100))
    end
    
    -- 3. Scan Backpack
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    debug.AddText("🎒 SCANNING BACKPACK", Color3.fromRGB(100, 200, 255))
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        debug.AddText("Backpack found!", Color3.fromRGB(100, 255, 100))
        debug.AddText("Backpack Children:", Color3.fromRGB(200, 200, 255))
        
        for _, child in pairs(backpack:GetChildren()) do
            debug.AddText("  → " .. child.Name .. " (" .. child.ClassName .. ")", Color3.fromRGB(255, 255, 200))
            
            -- If it's a tool, scan deeper
            if child:IsA("Tool") then
                debug.AddText("    └─ Children of " .. child.Name .. ":", Color3.fromRGB(150, 150, 255))
                for _, subChild in pairs(child:GetChildren()) do
                    debug.AddText("      → " .. subChild.Name .. " (" .. subChild.ClassName .. ")", Color3.fromRGB(200, 200, 255))
                end
                
                -- Check for attributes
                debug.AddText("    └─ Attributes of " .. child.Name .. ":", Color3.fromRGB(255, 200, 150))
                for attr, value in pairs(child:GetAttributes()) do
                    debug.AddText("      → " .. attr .. " = " .. tostring(value), Color3.fromRGB(255, 255, 200))
                end
            end
        end
    else
        debug.AddText("❌ Backpack not found!", Color3.fromRGB(255, 100, 100))
    end
    
    -- 4. Scan PlayerGui
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    debug.AddText("🖥️ SCANNING PLAYER GUI", Color3.fromRGB(100, 200, 255))
    
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        debug.AddText("PlayerGui found!", Color3.fromRGB(100, 255, 100))
        debug.AddText("PlayerGui Children:", Color3.fromRGB(200, 200, 255))
        
        for _, child in pairs(playerGui:GetChildren()) do
            debug.AddText("  → " .. child.Name .. " (" .. child.ClassName .. ")", Color3.fromRGB(255, 255, 200))
            
            -- Look for fishing-related GUI
            if child.Name:lower():find("fish") or child.Name:lower():find("rod") or child.Name:lower():find("catch") then
                debug.AddText("    🎣 FISHING RELATED GUI FOUND!", Color3.fromRGB(100, 255, 100))
                
                -- Scan deeper into fishing GUI
                for _, subChild in pairs(child:GetChildren()) do
                    debug.AddText("      → " .. subChild.Name .. " (" .. subChild.ClassName .. ")", Color3.fromRGB(200, 200, 255))
                end
            end
        end
    else
        debug.AddText("❌ PlayerGui not found!", Color3.fromRGB(255, 100, 100))
    end
    
    -- 5. Scan leaderstats
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    debug.AddText("📈 SCANNING LEADERSTATS", Color3.fromRGB(100, 200, 255))
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        debug.AddText("leaderstats found!", Color3.fromRGB(100, 255, 100))
        debug.AddText("Leaderstats values:", Color3.fromRGB(200, 200, 255))
        
        for _, stat in pairs(leaderstats:GetChildren()) do
            debug.AddText("  → " .. stat.Name .. " = " .. tostring(stat.Value) .. " (" .. stat.ClassName .. ")", Color3.fromRGB(255, 255, 200))
        end
    else
        debug.AddText("❌ leaderstats not found!", Color3.fromRGB(255, 100, 100))
    end
    
    -- 6. Scan for ANY fishing-related objects
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    debug.AddText("🎣 SCANNING FOR FISHING OBJECTS", Color3.fromRGB(100, 200, 255))
    
    local fishingKeywords = {
        "fish", "rod", "catch", "reel", "cast", "hook", "bait", "line", "bobber",
        "fishing", "angler", "hook", "net", "trap", "harpoon", "spear"
    }
    
    local function scanForFishingObjects(parent, path)
        for _, child in pairs(parent:GetChildren()) do
            local currentPath = path .. "." .. child.Name
            local lowerName = child.Name:lower()
            
            -- Check if name contains fishing keywords
            for _, keyword in pairs(fishingKeywords) do
                if lowerName:find(keyword) then
                    debug.AddText("🎣 FOUND: " .. currentPath .. " (" .. child.ClassName .. ")", Color3.fromRGB(100, 255, 100))
                    
                    -- Show details
                    if child:IsA("Tool") or child:IsA("Model") then
                        debug.AddText("  └─ Details:", Color3.fromRGB(200, 200, 255))
                        for _, subChild in pairs(child:GetChildren()) do
                            debug.AddText("    → " .. subChild.Name .. " (" .. subChild.ClassName .. ")", Color3.fromRGB(255, 255, 200))
                        end
                        
                        -- Show attributes
                        for attr, value in pairs(child:GetAttributes()) do
                            debug.AddText("    → Attribute: " .. attr .. " = " .. tostring(value), Color3.fromRGB(255, 200, 150))
                        end
                    end
                    break
                end
            end
            
            -- Recursively scan children
            if #child:GetChildren() > 0 then
                scanForFishingObjects(child, currentPath)
            end
        end
    end
    
    -- Scan player and all children
    scanForFishingObjects(player, "Player")
    
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    debug.AddText("✅ COMPREHENSIVE SCAN COMPLETE!", Color3.fromRGB(100, 255, 100))
    debug.AddText("=====================================", Color3.fromRGB(255, 255, 100))
end

-- Specific function to find fishing rod
local function findFishingRod()
    debug.AddText("🎣 STARTING FISHING ROD SEARCH", Color3.fromRGB(255, 255, 100))
    debug.AddText("=====================================", Color3.fromRGB(255, 255, 100))
    
    local rodsFound = 0
    
    -- Function to check if an object is a fishing rod
    local function isFishingRod(obj)
        if not obj then return false end
        
        local name = obj.Name:lower()
        
        -- Check for rod keywords
        local rodKeywords = {
            "rod", "fishing", "pole", "stick", "line", "reel", "cast", "hook"
        }
        
        for _, keyword in pairs(rodKeywords) do
            if name:find(keyword) then
                return true
            end
        end
        
        return false
    end
    
    -- Scan character
    debug.AddText("🦴 Scanning Character for rods:", Color3.fromRGB(200, 200, 255))
    if character then
        for _, child in pairs(character:GetChildren()) do
            if isFishingRod(child) then
                rodsFound = rodsFound + 1
                debug.AddText("  🎣 ROD FOUND: " .. child.Name .. " (" .. child.ClassName .. ")", Color3.fromRGB(100, 255, 100))
                
                -- Show details
                debug.AddText("    └─ Children:", Color3.fromRGB(200, 200, 255))
                for _, subChild in pairs(child:GetChildren()) do
                    debug.AddText("      → " .. subChild.Name .. " (" .. subChild.ClassName .. ")", Color3.fromRGB(255, 255, 200))
                end
                
                -- Show attributes
                debug.AddText("    └─ Attributes:", Color3.fromRGB(255, 200, 150))
                for attr, value in pairs(child:GetAttributes()) do
                    debug.AddText("      → " .. attr .. " = " .. tostring(value), Color3.fromRGB(255, 255, 200))
                end
            end
        end
    end
    
    -- Scan backpack
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    debug.AddText("🎒 Scanning Backpack for rods:", Color3.fromRGB(200, 200, 255))
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if isFishingRod(child) then
                rodsFound = rodsFound + 1
                debug.AddText("  🎣 ROD FOUND: " .. child.Name .. " (" .. child.ClassName .. ")", Color3.fromRGB(100, 255, 100))
                
                -- Show details
                debug.AddText("    └─ Children:", Color3.fromRGB(200, 200, 255))
                for _, subChild in pairs(child:GetChildren()) do
                    debug.AddText("      → " .. subChild.Name .. " (" .. subChild.ClassName .. ")", Color3.fromRGB(255, 255, 200))
                end
                
                -- Show attributes
                debug.AddText("    └─ Attributes:", Color3.fromRGB(255, 200, 150))
                for attr, value in pairs(child:GetAttributes()) do
                    debug.AddText("      → " .. attr .. " = " .. tostring(value), Color3.fromRGB(255, 255, 200))
                end
            end
        end
    end
    
    -- Scan player GUI for rod-related elements
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    debug.AddText("🖥️ Scanning PlayerGui for rod elements:", Color3.fromRGB(200, 200, 255))
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, child in pairs(playerGui:GetChildren()) do
            if isFishingRod(child) then
                rodsFound = rodsFound + 1
                debug.AddText("  🎣 ROD GUI ELEMENT: " .. child.Name .. " (" .. child.ClassName .. ")", Color3.fromRGB(100, 255, 100))
            end
        end
    end
    
    -- Summary
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    if rodsFound > 0 then
        debug.AddText("✅ FOUND " .. rodsFound .. " FISHING ROD(S)!", Color3.fromRGB(100, 255, 100))
    else
        debug.AddText("❌ NO FISHING RODS FOUND!", Color3.fromRGB(255, 100, 100))
        debug.AddText("💡 TIPS:", Color3.fromRGB(255, 200, 100))
        debug.AddText("  1. Make sure you have equipped a fishing rod", Color3.fromRGB(255, 255, 200))
        debug.AddText("  2. Check if the rod is in your backpack", Color3.fromRGB(255, 255, 200))
        debug.AddText("  3. Try clicking 'Scan All' to see all items", Color3.fromRGB(255, 255, 200))
        debug.AddText("  4. The rod might have a different name", Color3.fromRGB(255, 255, 200))
    end
    
    debug.AddText("=====================================", Color3.fromRGB(255, 255, 100))
end

-- Auto-scan on start
debug.AddText("🔍 FISH IT SUPER DEBUG STARTED", Color3.fromRGB(255, 255, 100))
debug.AddText("=====================================", Color3.fromRGB(255, 255, 100))
debug.AddText("📋 Instructions:", Color3.fromRGB(200, 200, 255))
debug.AddText("  1. Click '🔍 Scan All' for complete scan", Color3.fromRGB(255, 255, 200))
debug.AddText("  2. Click '🎣 Find Rod' to search specifically for rods", Color3.fromRGB(255, 255, 200))
debug.AddText("  3. Click '📋 Copy' to copy all debug info", Color3.fromRGB(255, 255, 200))
debug.AddText("  4. Make sure your fishing rod is equipped!", Color3.fromRGB(255, 200, 100))
debug.AddText("", Color3.fromRGB(255, 255, 255))

-- Initial scan
comprehensiveScan()

-- Instructions
print("=== FISH IT SUPER DEBUG INSTRUCTIONS ===")
print("1. Use '🔍 Scan All' to scan everything")
print("2. Use '🎣 Find Rod' to search specifically for fishing rods")
print("3. Look for GREEN text indicating found items")
print("4. Copy the results and send to me for analysis")
print("5. Make sure your fishing rod is equipped!")
print("================================")

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Super Debug Ready",
        Text = "Use Scan All or Find Rod to locate your fishing rod!",
        Duration = 5
    })
end)
