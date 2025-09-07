-- Fish It Debug Script
-- Created by AI Assistant
-- Features: Debug fishing rod, position, fish detection

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local debugGui = nil
local debugEnabled = true

-- Debug GUI Creation
local function createDebugGUI()
    -- Destroy existing debug GUI
    if debugGui then
        debugGui:Destroy()
    end
    
    debugGui = Instance.new("ScreenGui")
    debugGui.Name = "FishItDebugGUI"
    debugGui.ResetOnSpawn = false
    debugGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main Debug Frame
    local debugFrame = Instance.new("Frame")
    debugFrame.Name = "DebugFrame"
    debugFrame.Size = UDim2.new(0, 400, 0, 500)
    debugFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
    debugFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    debugFrame.BorderSizePixel = 0
    debugFrame.Active = true
    debugFrame.Draggable = true
    debugFrame.Parent = debugGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = debugFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔍 FISH IT DEBUG TOOL 🔍"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = debugFrame
    
    -- Scrolling Frame for debug info
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.Parent = debugFrame
    
    -- Content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.Position = UDim2.new(0, 0, 0, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    contentFrame.Parent = scrollFrame
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Function to add debug text
    local function addDebugText(text, color)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 20)
        label.Position = UDim2.new(0, 5, 0, #contentFrame:GetChildren() * 22)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        label.TextScaled = false
        label.Font = Enum.Font.Code
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Top
        label.TextWrapped = true
        label.Parent = contentFrame
        
        -- Update canvas size
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 22)
        
        -- Auto scroll to bottom
        scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.CanvasSize.Y.Offset)
    end
    
    -- Clear button
    local clearButton = Instance.new("TextButton")
    clearButton.Name = "ClearButton"
    clearButton.Size = UDim2.new(0, 80, 0, 25)
    clearButton.Position = UDim2.new(1, -85, 0, 5)
    clearButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    clearButton.Text = "Clear"
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.Font = Enum.Font.SourceSansBold
    clearButton.TextSize = 12
    clearButton.Parent = debugFrame
    
    clearButton.MouseButton1Click:Connect(function()
        for _, child in pairs(contentFrame:GetChildren()) do
            child:Destroy()
        end
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    end)
    
    -- Return functions
    return {
        AddText = addDebugText,
        GUI = debugGui
    }
end

-- Initialize debug
local debug = createDebugGUI()

-- Debug functions
local function debugPlayerInfo()
    debug.AddText("=== PLAYER INFO ===", Color3.fromRGB(100, 200, 255))
    debug.AddText("Player Name: " .. player.Name, Color3.fromRGB(255, 255, 255))
    debug.AddText("Player ID: " .. player.UserId, Color3.fromRGB(255, 255, 255))
    debug.AddText("Character exists: " .. tostring(character ~= nil), Color3.fromRGB(255, 255, 255))
    
    if humanoidRootPart then
        local pos = humanoidRootPart.Position
        debug.AddText(string.format("Position: X=%.2f, Y=%.2f, Z=%.2f", pos.X, pos.Y, pos.Z), Color3.fromRGB(100, 255, 100))
    end
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

local function debugCharacterItems()
    debug.AddText("=== CHARACTER ITEMS ===", Color3.fromRGB(100, 200, 255))
    
    if not character then
        debug.AddText("Character not found!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local itemsFound = 0
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            itemsFound = itemsFound + 1
            debug.AddText(string.format("Item %d: %s (Class: %s)", itemsFound, item.Name, item.ClassName), Color3.fromRGB(255, 255, 150))
            
            -- Check if it's a fishing rod
            if item.Name:lower():find("rod") or item.Name:lower():find("fishing") then
                debug.AddText("  → FISHING ROD DETECTED!", Color3.fromRGB(100, 255, 100))
                debug.AddText("  → Item ID: " .. tostring(item), Color3.fromRGB(150, 255, 150))
                
                -- Check for rod properties
                for _, prop in pairs(item:GetChildren()) do
                    debug.AddText("  → Child: " .. prop.Name .. " (" .. prop.ClassName .. ")", Color3.fromRGB(200, 200, 255))
                end
                
                -- Check for attributes
                for attr, value in pairs(item:GetAttributes()) do
                    debug.AddText("  → Attribute: " .. attr .. " = " .. tostring(value), Color3.fromRGB(255, 200, 150))
                end
            end
            
            -- Check for any tool properties
            if item:IsA("Tool") then
                debug.AddText("  → Tool Tip: " .. (item.ToolTip or "No tip"), Color3.fromRGB(200, 200, 200))
            end
        end
    end
    
    if itemsFound == 0 then
        debug.AddText("No items found in character!", Color3.fromRGB(255, 150, 100))
    end
    
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

local function debugBackpackItems()
    debug.AddText("=== BACKPACK ITEMS ===", Color3.fromRGB(100, 200, 255))
    
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then
        debug.AddText("Backpack not found!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local itemsFound = 0
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            itemsFound = itemsFound + 1
            debug.AddText(string.format("Backpack Item %d: %s", itemsFound, item.Name), Color3.fromRGB(255, 255, 150))
            
            -- Check if it's a fishing rod
            if item.Name:lower():find("rod") or item.Name:lower():find("fishing") then
                debug.AddText("  → FISHING ROD IN BACKPACK!", Color3.fromRGB(255, 200, 100))
                debug.AddText("  → Item ID: " .. tostring(item), Color3.fromRGB(150, 255, 150))
                
                -- Check for rod properties
                for _, prop in pairs(item:GetChildren()) do
                    debug.AddText("  → Child: " .. prop.Name .. " (" .. prop.ClassName .. ")", Color3.fromRGB(200, 200, 255))
                end
            end
        end
    end
    
    if itemsFound == 0 then
        debug.AddText("No items found in backpack!", Color3.fromRGB(255, 150, 100))
    end
    
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

local function debugPlayerGui()
    debug.AddText("=== PLAYER GUI ===", Color3.fromRGB(100, 200, 255))
    
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then
        debug.AddText("PlayerGui not found!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local fishingRelated = 0
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name:lower():find("fish") or gui.Name:lower():find("rod") or gui.Name:lower():find("catch") then
            fishingRelated = fishingRelated + 1
            debug.AddText("Fishing GUI: " .. gui.Name .. " (" .. gui.ClassName .. ")", Color3.fromRGB(100, 255, 150))
            
            -- Check for important values
            if gui:FindFirstChild("Values") then
                debug.AddText("  → Has Values folder!", Color3.fromRGB(150, 255, 150))
                for _, value in pairs(gui.Values:GetChildren()) do
                    debug.AddText("  → Value: " .. value.Name .. " = " .. tostring(value.Value), Color3.fromRGB(200, 200, 255))
                end
            end
        end
    end
    
    if fishingRelated == 0 then
        debug.AddText("No fishing-related GUI found!", Color3.fromRGB(255, 150, 100))
    end
    
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

local function debugReplicatedStorage()
    debug.AddText("=== REPLICATED STORAGE ===", Color3.fromRGB(100, 200, 255))
    
    -- Look for fishing-related remotes
    local remotes = {}
    local function findRemotes(parent)
        for _, item in pairs(parent:GetChildren()) do
            if item:IsA("RemoteEvent") or item:IsA("RemoteFunction") then
                table.insert(remotes, item)
            end
            if #item:GetChildren() > 0 then
                findRemotes(item)
            end
        end
    end
    
    findRemotes(ReplicatedStorage)
    
    debug.AddText("Found " .. #remotes .. " remote events/functions:", Color3.fromRGB(255, 255, 150))
    for _, remote in pairs(remotes) do
        local remoteType = remote:IsA("RemoteEvent") and "RemoteEvent" or "RemoteFunction"
        local isFishingRelated = remote.Name:lower():find("fish") or remote.Name:lower():find("rod") or 
                               remote.Name:lower():find("cast") or remote.Name:lower():find("reel") or
                               remote.Name:lower():find("catch")
        
        local color = isFishingRelated and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 200, 200)
        debug.AddText("  → " .. remote.Name .. " (" .. remoteType .. ")", color)
    end
    
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

local function debugLeaderstats()
    debug.AddText("=== LEADERSTATS ===", Color3.fromRGB(100, 200, 255))
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        debug.AddText("leaderstats not found!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    for _, stat in pairs(leaderstats:GetChildren()) do
        if stat:IsA("IntValue") or stat:IsA("NumberValue") then
            debug.AddText(stat.Name .. ": " .. tostring(stat.Value), Color3.fromRGB(255, 255, 150))
        end
    end
    
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

-- Fish detection function
local function setupFishDetection()
    debug.AddText("=== FISH DETECTION SETUP ===", Color3.fromRGB(100, 200, 255))
    
    -- Monitor for fish caught
    local connection
    connection = player.ChildAdded:Connect(function(child)
        if child:IsA("IntValue") or child:IsA("NumberValue") then
            if child.Name:lower():find("fish") or child.Name:lower():find("catch") then
                debug.AddText("🎣 FISH DETECTED: " .. child.Name .. " = " .. tostring(child.Value), Color3.fromRGB(100, 255, 100))
            end
        end
    end)
    
    -- Monitor for tool changes
    local toolConnection
    toolConnection = character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            debug.AddText("🎣 TOOL EQUIPPED: " .. child.Name, Color3.fromRGB(100, 255, 150))
            
            if child.Name:lower():find("rod") or child.Name:lower():find("fishing") then
                debug.AddText("  → FISHING ROD EQUIPPED!", Color3.fromRGB(100, 255, 100))
            end
        end
    end)
    
    character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            debug.AddText("📤 TOOL UNEQUIPPED: " .. child.Name, Color3.fromRGB(255, 150, 100))
        end
    end)
    
    debug.AddText("Fish detection monitoring started!", Color3.fromRGB(100, 255, 100))
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

-- Position tracking
local function setupPositionTracking()
    spawn(function()
        while debugEnabled do
            if humanoidRootPart then
                local pos = humanoidRootPart.Position
                local debugText = string.format("POS: X=%.1f Y=%.1f Z=%.1f", pos.X, pos.Y, pos.Z)
                
                -- Update a simple position display
                if debug.GUI and debug.GUI:FindFirstChild("DebugFrame") then
                    local existingPosLabel = debug.GUI.DebugFrame:FindFirstChild("PositionLabel")
                    if not existingPosLabel then
                        local posLabel = Instance.new("TextLabel")
                        posLabel.Name = "PositionLabel"
                        posLabel.Size = UDim2.new(0, 200, 0, 20)
                        posLabel.Position = UDim2.new(1, -210, 0, 35)
                        posLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        posLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                        posLabel.Font = Enum.Font.Code
                        posLabel.TextSize = 12
                        posLabel.Parent = debug.GUI.DebugFrame
                    end
                    debug.GUI.DebugFrame.PositionLabel.Text = debugText
                end
            end
            wait(0.5)
        end
    end)
end

-- Run all debug functions
debug.AddText("🔍 FISH IT DEBUG TOOL STARTED", Color3.fromRGB(255, 255, 100))
debug.AddText("=====================================", Color3.fromRGB(255, 255, 100))
debug.AddText("", Color3.fromRGB(255, 255, 255))

debugPlayerInfo()
debugCharacterItems()
debugBackpackItems()
debugPlayerGui()
debugReplicatedStorage()
debugLeaderstats()
setupFishDetection()
setupPositionTracking()

debug.AddText("✅ DEBUG COMPLETE!", Color3.fromRGB(100, 255, 100))
debug.AddText("Equip your fishing rod to see detection!", Color3.fromRGB(255, 255, 150))
debug.AddText("Look for green text indicating fishing rods!", Color3.fromRGB(255, 255, 150))

-- Instructions
print("=== DEBUG TOOL INSTRUCTIONS ===")
print("1. Check the debug window for fishing rod detection")
print("2. Look for green text indicating fishing rods")
print("3. Equip/unequip rods to see real-time detection")
print("4. Check position tracking at top-right of debug window")
print("5. Monitor for fish catch events")
print("================================")

-- Notification
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Debug Tool Ready",
        Text = "Check the debug window for fishing rod info!",
        Duration = 5
    })
end)
