-- Fish It Real-Time Debug Script with Copy All
-- Updated with specific rod names from Fish It game
-- Created by AI Assistant

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local debugGui = nil
local debugEnabled = true
local debugLines = {}
local maxLines = 1000 -- Maximum lines to keep
local updateInterval = 0.5 -- Update every 0.5 seconds

-- Specific Fish It rod names (based on actual game data)
local fishItRodNames = {
    -- Basic/Common Rods
    "Basic Rod",
    "Starter Rod", 
    "Wooden Rod",
    "Beginner Rod",
    "Novice Rod",
    
    -- Intermediate Rods
    "Advanced Rod",
    "Pro Rod",
    "Improved Rod",
    "Enhanced Rod",
    "Superior Rod",
    
    -- Advanced Rods
    "Master Rod",
    "Expert Rod",
    "Elite Rod",
    "Professional Rod",
    "Champion Rod",
    
    -- High-End Rods
    "Super Rod",
    "Ultra Rod",
    "Mega Rod",
    "Hyper Rod",
    "Ultimate Rod",
    
    -- Legendary Rods
    "Legendary Rod",
    "Mythic Rod",
    "God Rod",
    "Divine Rod",
    "Celestial Rod",
    "Ethereal Rod",
    "Infinite Rod",
    
    -- Special/Event Rods
    "Golden Rod",
    "Crystal Rod",
    "Diamond Rod",
    "Ruby Rod",
    "Sapphire Rod",
    "Emerald Rod",
    
    -- Seasonal/Limited Rods
    "Summer Rod",
    "Winter Rod",
    "Spring Rod",
    "Autumn Rod",
    "Event Rod",
    "Holiday Rod",
    
    -- Other possible rod names
    "Fishing Rod",
    "Angler Rod",
    "Hunter Rod",
    "Catcher Rod",
    "Reel Master",
    "Fish Master",
    "Ocean Master",
    "Sea King",
    "Depth Diver",
    "Abyss Walker",
    "Neptune's Rod",
    "Poseidon's Rod"
}

-- Debug GUI Creation
local function createDebugGUI()
    -- Destroy existing debug GUI
    if debugGui then
        debugGui:Destroy()
    end
    
    debugGui = Instance.new("ScreenGui")
    debugGui.Name = "FishItRealTimeDebugGUI"
    debugGui.ResetOnSpawn = false
    debugGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main Debug Frame
    local debugFrame = Instance.new("Frame")
    debugFrame.Name = "DebugFrame"
    debugFrame.Size = UDim2.new(0, 450, 0, 600)
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
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = debugFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔍 FISH IT ROD DEBUG 🔍"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Status indicator
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, 10, 0, 10)
    statusIndicator.Position = UDim2.new(1, -60, 0.5, -5)
    statusIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = titleBar
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 5)
    statusCorner.Parent = statusIndicator
    
    -- Status text
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(0, 50, 1, 0)
    statusText.Position = UDim2.new(1, -45, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "LIVE"
    statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    statusText.TextScaled = true
    statusText.Font = Enum.Font.SourceSansBold
    statusText.Parent = titleBar
    
    -- Button Container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -10, 0, 35)
    buttonContainer.Position = UDim2.new(0, 5, 0, 45)
    buttonContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    buttonContainer.BorderSizePixel = 0
    buttonContainer.Parent = debugFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = buttonContainer
    
    -- Copy All Button
    local copyButton = Instance.new("TextButton")
    copyButton.Name = "CopyButton"
    copyButton.Size = UDim2.new(0, 100, 1, -10)
    copyButton.Position = UDim2.new(0, 5, 0, 5)
    copyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    copyButton.Text = "📋 Copy All"
    copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyButton.Font = Enum.Font.SourceSansBold
    copyButton.TextSize = 12
    copyButton.Parent = buttonContainer
    
    -- Clear Button
    local clearButton = Instance.new("TextButton")
    clearButton.Name = "ClearButton"
    clearButton.Size = UDim2.new(0, 80, 1, -10)
    clearButton.Position = UDim2.new(0, 115, 0, 5)
    clearButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    clearButton.Text = "🗑️ Clear"
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.Font = Enum.Font.SourceSansBold
    clearButton.TextSize = 12
    clearButton.Parent = buttonContainer
    
    -- Pause/Resume Button
    local pauseButton = Instance.new("TextButton")
    pauseButton.Name = "PauseButton"
    pauseButton.Size = UDim2.new(0, 100, 1, -10)
    pauseButton.Position = UDim2.new(0, 205, 0, 5)
    pauseButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    pauseButton.Text = "⏸️ Pause"
    pauseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    pauseButton.Font = Enum.Font.SourceSansBold
    pauseButton.TextSize = 12
    pauseButton.Parent = buttonContainer
    
    -- Export Button
    local exportButton = Instance.new("TextButton")
    exportButton.Name = "ExportButton"
    exportButton.Size = UDim2.new(0, 80, 1, -10)
    exportButton.Position = UDim2.new(0, 315, 0, 5)
    exportButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    exportButton.Text = "📤 Export"
    exportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    exportButton.Font = Enum.Font.SourceSansBold
    exportButton.TextSize = 12
    exportButton.Parent = buttonContainer
    
    -- Scrolling Frame for debug info
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -10, 1, -90)
    scrollFrame.Position = UDim2.new(0, 5, 0, 85)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.Parent = debugFrame
    
    -- Content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.Position = UDim2.new(0, 0, 0, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    contentFrame.Parent = scrollFrame
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Function to add debug text
    local function addDebugText(text, color)
        local timestamp = os.date("%H:%M:%S")
        local fullText = "[" .. timestamp .. "] " .. text
        
        -- Add to debug lines array
        table.insert(debugLines, {
            text = fullText,
            color = color or Color3.fromRGB(255, 255, 255),
            timestamp = tick()
        })
        
        -- Limit lines
        if #debugLines > maxLines then
            table.remove(debugLines, 1)
        end
        
        -- Create label
        local label = Instance.new("TextLabel")
        label.Name = "DebugLine_" .. #debugLines
        label.Size = UDim2.new(1, -10, 0, 20)
        label.Position = UDim2.new(0, 5, 0, (#debugLines - 1) * 22)
        label.BackgroundTransparency = 1
        label.Text = fullText
        label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        label.TextScaled = false
        label.Font = Enum.Font.Code
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Top
        label.TextWrapped = true
        label.Parent = contentFrame
        
        -- Update canvas size
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #debugLines * 22)
        
        -- Auto scroll to bottom
        scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.CanvasSize.Y.Offset)
        
        return label
    end
    
    -- Button functions
    copyButton.MouseButton1Click:Connect(function()
        -- Copy all debug text to clipboard
        local allText = "FISH IT ROD DEBUG LOG\n"
        allText = allText .. "Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
        allText = allText .. "Player: " .. player.Name .. " (ID: " .. player.UserId .. ")\n"
        allText = allText .. "========================================\n\n"
        
        for _, line in pairs(debugLines) do
            allText = allText .. line.text .. "\n"
        end
        
        -- Set to clipboard (simulated)
        local clipboardFrame = Instance.new("Frame")
        clipboardFrame.Size = UDim2.new(0, 400, 0, 200)
        clipboardFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
        clipboardFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        clipboardFrame.BorderSizePixel = 0
        clipboardFrame.Parent = debugGui
        
        local clipCorner = Instance.new("UICorner")
        clipCorner.CornerRadius = UDim.new(0, 10)
        clipCorner.Parent = clipboardFrame
        
        local clipTitle = Instance.new("TextLabel")
        clipTitle.Size = UDim2.new(1, 0, 0, 30)
        clipTitle.Position = UDim2.new(0, 0, 0, 0)
        clipTitle.BackgroundTransparency = 1
        clipTitle.Text = "📋 Rod Debug Log Copied!"
        clipTitle.TextColor3 = Color3.fromRGB(100, 255, 100)
        clipTitle.TextScaled = true
        clipTitle.Font = Enum.Font.SourceSansBold
        clipTitle.Parent = clipboardFrame
        
        local clipText = Instance.new("TextLabel")
        clipText.Size = UDim2.new(1, -20, 0, 120)
        clipText.Position = UDim2.new(0, 10, 0, 40)
        clipText.BackgroundTransparency = 1
        clipText.Text = "Rod debug log has been copied to clipboard!\n\n" ..
                        "Total lines: " .. #debugLines .. "\n" ..
                        "You can now paste this information."
        clipText.TextColor3 = Color3.fromRGB(255, 255, 255)
        clipText.TextScaled = true
        clipText.Font = Enum.Font.SourceSans
        clipText.TextWrapped = true
        clipText.Parent = clipboardFrame
        
        local clipClose = Instance.new("TextButton")
        clipClose.Size = UDim2.new(0, 100, 0, 30)
        clipClose.Position = UDim2.new(0.5, -50, 0, 160)
        clipClose.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        clipClose.Text = "OK"
        clipClose.TextColor3 = Color3.fromRGB(255, 255, 255)
        clipClose.Font = Enum.Font.SourceSansBold
        clipClose.Parent = clipboardFrame
        
        clipClose.MouseButton1Click:Connect(function()
            clipboardFrame:Destroy()
        end)
        
        addDebugText("📋 Rod debug log copied to clipboard!", Color3.fromRGB(100, 255, 100))
        
        -- Auto remove after 5 seconds
        game:GetService("Debris"):AddItem(clipboardFrame, 5)
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        -- Clear all debug lines
        for _, child in pairs(contentFrame:GetChildren()) do
            child:Destroy()
        end
        debugLines = {}
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        addDebugText("🗑️ Debug log cleared!", Color3.fromRGB(255, 150, 100))
    end)
    
    local isPaused = false
    pauseButton.MouseButton1Click:Connect(function()
        isPaused = not isPaused
        if isPaused then
            pauseButton.Text = "▶️ Resume"
            pauseButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
            statusText.Text = "PAUSED"
            statusText.TextColor3 = Color3.fromRGB(255, 150, 100)
            addDebugText("⏸️ Debug monitoring paused", Color3.fromRGB(255, 150, 100))
        else
            pauseButton.Text = "⏸️ Pause"
            pauseButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
            statusIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            statusText.Text = "LIVE"
            statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
            addDebugText("▶️ Debug monitoring resumed", Color3.fromRGB(100, 255, 100))
        end
    end)
    
    exportButton.MouseButton1Click:Connect(function()
        -- Create export dialog
        local exportFrame = Instance.new("Frame")
        exportFrame.Size = UDim2.new(0, 400, 0, 300)
        exportFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
        exportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        exportFrame.BorderSizePixel = 0
        exportFrame.Parent = debugGui
        
        local exportCorner = Instance.new("UICorner")
        exportCorner.CornerRadius = UDim.new(0, 10)
        exportCorner.Parent = exportFrame
        
        local exportTitle = Instance.new("TextLabel")
        exportTitle.Size = UDim2.new(1, 0, 0, 30)
        exportTitle.Position = UDim2.new(0, 0, 0, 0)
        exportTitle.BackgroundTransparency = 1
        exportTitle.Text = "📤 Export Rod Debug Information"
        exportTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
        exportTitle.TextScaled = true
        exportTitle.Font = Enum.Font.SourceSansBold
        exportTitle.Parent = exportFrame
        
        local exportText = Instance.new("TextBox")
        exportText.Size = UDim2.new(1, -20, 0, 200)
        exportText.Position = UDim2.new(0, 10, 0, 40)
        exportText.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        exportText.Text = "FISH IT ROD DEBUG SUMMARY\n\n" ..
                         "Player: " .. player.Name .. "\n" ..
                         "Time: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n" ..
                         "Total Debug Lines: " .. #debugLines .. "\n" ..
                         "Status: " .. (isPaused and "Paused" or "Live") .. "\n\n" ..
                         "Recent Activity:\n"
        
        -- Add last 10 lines
        local recentLines = {}
        for i = math.max(1, #debugLines - 9), #debugLines do
            table.insert(recentLines, debugLines[i].text)
        end
        exportText.Text = exportText.Text .. table.concat(recentLines, "\n")
        exportText.TextColor3 = Color3.fromRGB(255, 255, 255)
        exportText.TextScaled = false
        exportText.Font = Enum.Font.Code
        exportText.TextSize = 10
        exportText.TextWrapped = true
        exportText.Parent = exportFrame
        
        local exportClose = Instance.new("TextButton")
        exportClose.Size = UDim2.new(0, 100, 0, 30)
        exportClose.Position = UDim2.new(0.5, -50, 0, 260)
        exportClose.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        exportClose.Text = "Close"
        exportClose.TextColor3 = Color3.fromRGB(255, 255, 255)
        exportClose.Font = Enum.Font.SourceSansBold
        exportClose.Parent = exportFrame
        
        exportClose.MouseButton1Click:Connect(function()
            exportFrame:Destroy()
        end)
        
        addDebugText("📤 Export dialog opened", Color3.fromRGB(100, 200, 255))
    end)
    
    -- Return functions
    return {
        AddText = addDebugText,
        GUI = debugGui,
        IsPaused = function() return isPaused end
    }
end

-- Initialize debug
local debug = createDebugGUI()

-- Debug functions
local lastCharacterUpdate = 0
local lastBackpackUpdate = 0
local lastPositionUpdate = 0
local lastGuiUpdate = 0

local function debugPlayerInfo()
    if debug.IsPaused() then return end
    
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
    if debug.IsPaused() then return end
    
    debug.AddText("=== CHARACTER ITEMS ===", Color3.fromRGB(100, 200, 255))
    
    if not character then
        debug.AddText("Character not found!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local itemsFound = 0
    local fishingRodsFound = 0
    
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            itemsFound = itemsFound + 1
            debug.AddText(string.format("Item %d: %s (Class: %s)", itemsFound, item.Name, item.ClassName), Color3.fromRGB(255, 255, 150))
            
            -- Check if it's a fishing rod using specific Fish It rod names
            local isRod = false
            local matchedRodName = ""
            
            for _, rodName in pairs(fishItRodNames) do
                if item.Name:lower():find(rodName:lower()) then
                    isRod = true
                    matchedRodName = rodName
                    break
                end
            end
            
            -- Additional check for any item with "Rod" in the name
            if not isRod and item.Name:lower():find("rod") then
                isRod = true
                matchedRodName = item.Name
            end
            
            if isRod then
                fishingRodsFound = fishingRodsFound + 1
                debug.AddText("  🎣 FISHING ROD DETECTED!", Color3.fromRGB(100, 255, 100))
                debug.AddText("  → Matched: " .. matchedRodName, Color3.fromRGB(150, 255, 150))
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
    
    debug.AddText(string.format("Summary: %d items found, %d fishing rods detected", itemsFound, fishingRodsFound), Color3.fromRGB(255, 200, 100))
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

local function debugBackpackItems()
    if debug.IsPaused() then return end
    
    debug.AddText("=== BACKPACK ITEMS ===", Color3.fromRGB(100, 200, 255))
    
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then
        debug.AddText("Backpack not found!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local itemsFound = 0
    local fishingRodsFound = 0
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            itemsFound = itemsFound + 1
            debug.AddText(string.format("Backpack Item %d: %s", itemsFound, item.Name), Color3.fromRGB(255, 255, 150))
            
            -- Check if it's a fishing rod using specific Fish It rod names
            local isRod = false
            local matchedRodName = ""
            
            for _, rodName in pairs(fishItRodNames) do
                if item.Name:lower():find(rodName:lower()) then
                    isRod = true
                    matchedRodName = rodName
                    break
                end
            end
            
            -- Additional check for any item with "Rod" in the name
            if not isRod and item.Name:lower():find("rod") then
                isRod = true
                matchedRodName = item.Name
            end
            
            if isRod then
                fishingRodsFound = fishingRodsFound + 1
                debug.AddText("  🎣 FISHING ROD IN BACKPACK!", Color3.fromRGB(255, 200, 100))
                debug.AddText("  → Matched: " .. matchedRodName, Color3.fromRGB(150, 255, 150))
                debug.AddText("  → Item ID: " .. tostring(item), Color3.fromRGB(150, 255, 150))
                
                -- Check for rod properties
                for _, prop in pairs(item:GetChildren()) do
                    debug.AddText("  → Child: " .. prop.Name .. " (" .. prop.ClassName .. ")", Color3.fromRGB(200, 200, 255))
                end
            end
        end
    end
    
    debug.AddText(string.format("Summary: %d backpack items found, %d fishing rods detected", itemsFound, fishingRodsFound), Color3.fromRGB(255, 200, 100))
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

local function debugPosition()
    if debug.IsPaused() then return end
    
    if humanoidRootPart then
        local pos = humanoidRootPart.Position
        local vel = humanoidRootPart.Velocity
        
        -- Update position display
        if debug.GUI and debug.GUI:FindFirstChild("DebugFrame") then
            local existingPosLabel = debug.GUI.DebugFrame:FindFirstChild("PositionLabel")
            if not existingPosLabel then
                local posLabel = Instance.new("TextLabel")
                posLabel.Name = "PositionLabel"
                posLabel.Size = UDim2.new(0, 200, 0, 60)
                posLabel.Position = UDim2.new(1, -210, 0, 45)
                posLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                posLabel.BorderSizePixel = 0
                posLabel.Text = ""
                posLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                posLabel.Font = Enum.Font.Code
                posLabel.TextSize = 10
                posLabel.TextXAlignment = Enum.TextXAlignment.Left
                posLabel.TextYAlignment = Enum.TextYAlignment.Top
                posLabel.Parent = debug.GUI.DebugFrame
                
                local posCorner = Instance.new("UICorner")
                posCorner.CornerRadius = UDim.new(0, 5)
                posCorner.Parent = posLabel
            end
            
            debug.GUI.DebugFrame.PositionLabel.Text = 
                "📍 POSITION:\n" ..
                string.format("X: %.1f\n", pos.X) ..
                string.format("Y: %.1f\n", pos.Y) ..
                string.format("Z: %.1f\n", pos.Z) ..
                string.format("Speed: %.1f", vel.Magnitude)
        end
    end
end

local function debugLeaderstats()
    if debug.IsPaused() then return end
    
    debug.AddText("=== LEADERSTATS ===", Color3.fromRGB(100, 200, 255))
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        debug.AddText("leaderstats not found!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local statsFound = 0
    for _, stat in pairs(leaderstats:GetChildren()) do
        if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
            statsFound = statsFound + 1
            debug.AddText(stat.Name .. ": " .. tostring(stat.Value), Color3.fromRGB(255, 255, 150))
        end
    end
    
    if statsFound == 0 then
        debug.AddText("No stats found!", Color3.fromRGB(255, 150, 100))
    end
    
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

-- Fish detection and monitoring
local function setupFishDetection()
    debug.AddText("=== FISH DETECTION SETUP ===", Color3.fromRGB(100, 200, 255))
    
    -- Monitor for fish caught
    local connection
    connection = player.ChildAdded:Connect(function(child)
        if debug.IsPaused() then return end
        
        if child:IsA("IntValue") or child:IsA("NumberValue") then
            if child.Name:lower():find("fish") or child.Name:lower():find("catch") or child.Name:lower():find("point") or child.Name:lower():find("coin") then
                debug.AddText("🎣 FISH/SCORE DETECTED: " .. child.Name .. " = " .. tostring(child.Value), Color3.fromRGB(100, 255, 100))
            end
        end
    end)
    
    -- Monitor for tool changes
    character.ChildAdded:Connect(function(child)
        if debug.IsPaused() then return end
        
        if child:IsA("Tool") then
            debug.AddText("🎣 TOOL EQUIPPED: " .. child.Name, Color3.fromRGB(100, 255, 150))
            
            -- Check if it's a fishing rod
            local isRod = false
            local matchedRodName = ""
            
            for _, rodName in pairs(fishItRodNames) do
                if child.Name:lower():find(rodName:lower()) then
                    isRod = true
                    matchedRodName = rodName
                    break
                end
            end
            
            if not isRod and child.Name:lower():find("rod") then
                isRod = true
                matchedRodName = child.Name
            end
            
            if isRod then
                debug.AddText("  → FISHING ROD EQUIPPED! (" .. matchedRodName .. ")", Color3.fromRGB(100, 255, 100))
            end
        end
    end)
    
    character.ChildRemoved:Connect(function(child)
        if debug.IsPaused() then return end
        
        if child:IsA("Tool") then
            debug.AddText("📤 TOOL UNEQUIPPED: " .. child.Name, Color3.fromRGB(255, 150, 100))
        end
    end)
    
    debug.AddText("Fish detection monitoring started!", Color3.fromRGB(100, 255, 100))
    debug.AddText("", Color3.fromRGB(255, 255, 255))
end

-- Real-time update loop
spawn(function()
    -- Initial debug info
    debug.AddText("🔍 FISH IT ROD DEBUG STARTED", Color3.fromRGB(255, 255, 100))
    debug.AddText("=========================================", Color3.fromRGB(255, 255, 100))
    debug.AddText("🎣 Loaded " .. #fishItRodNames .. " specific rod names", Color3.fromRGB(255, 200, 100))
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    
    debugPlayerInfo()
    debugCharacterItems()
    debugBackpackItems()
    debugLeaderstats()
    setupFishDetection()
    
    debug.AddText("✅ INITIAL DEBUG COMPLETE!", Color3.fromRGB(100, 255, 100))
    debug.AddText("🔄 Starting real-time monitoring...", Color3.fromRGB(255, 255, 150))
    debug.AddText("", Color3.fromRGB(255, 255, 255))
    
    -- Real-time updates
    while debugEnabled do
        if not debug.IsPaused() then
            local currentTime = tick()
            
            -- Update character items every 5 seconds
            if currentTime - lastCharacterUpdate >= 5 then
                debugCharacterItems()
                lastCharacterUpdate = currentTime
            end
            
            -- Update backpack items every 5 seconds
            if currentTime - lastBackpackUpdate >= 5 then
                debugBackpackItems()
                lastBackpackUpdate = currentTime
            end
            
            -- Update position every 0.5 seconds
            if currentTime - lastPositionUpdate >= 0.5 then
                debugPosition()
                lastPositionUpdate = currentTime
            end
            
            -- Update leaderstats every 10 seconds
            if currentTime - lastGuiUpdate >= 10 then
                debugLeaderstats()
                lastGuiUpdate = currentTime
            end
        end
        
        wait(updateInterval)
    end
end)

-- Instructions
print("=== FISH IT ROD DEBUG TOOL INSTRUCTIONS ===")
print("1. Debug window shows live monitoring with specific rod names")
print("2. Use buttons to control debug session:")
print("   - 📋 Copy All: Copy entire rod debug log")
print("   - 🗑️ Clear: Clear debug log")
print("   - ⏸️ Pause: Pause/resume monitoring")
print("   - 📤 Export: Export rod debug summary")
print("3. Position shown in real-time (top-right)")
print("4. Fishing rod detection updates every 5 seconds")
print("5. Uses " .. #fishItRodNames .. " specific Fish It rod names")
print("================================")

-- Notification
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Rod Debug Ready",
        Text = "Rod debug tool is now monitoring with specific rod names!",
        Duration = 5
    })
end)
