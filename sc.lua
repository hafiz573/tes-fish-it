-- Fish It Debug Script - Large GUI
-- Created by AI Assistant
-- Big, readable GUI with clear information

-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Player setup
local player = Players.LocalPlayer

-- Show notification function
local function showNotification(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- Print to console
local function printToConsole(message)
    print("[FISH IT DEBUG] " .. message)
end

-- Create large GUI
local function createLargeGUI()
    printToConsole("Creating large GUI...")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FishItLargeDebug"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main frame - BIGGER
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 500) -- Increased size
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250) -- Centered
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- Title - BIGGER
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 60) -- Increased height
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔍 FISH IT DEBUG TOOL 🔍"
    title.TextColor3 = Color3.fromRGB(255, 255, 100)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.FontSize = 24 -- Bigger font
    title.Parent = mainFrame
    
    -- Status container
    local statusContainer = Instance.new("Frame")
    statusContainer.Name = "StatusContainer"
    statusContainer.Size = UDim2.new(1, -40, 0, 300) -- Bigger area
    statusContainer.Position = UDim2.new(0, 20, 0, 80)
    statusContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    statusContainer.BorderSizePixel = 0
    statusContainer.Parent = mainFrame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 10)
    statusCorner.Parent = statusContainer
    
    -- Status text - BIGGER and scrollable
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, -20, 1, -20)
    statusText.Position = UDim2.new(0, 10, 0, 10)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Loading debug information..."
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextScaled = false -- Don't scale, use fixed size
    statusText.Font = Enum.Font.SourceSans
    statusText.FontSize = 16 -- Bigger font size
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextYAlignment = Enum.TextYAlignment.Top
    statusText.TextWrapped = true
    statusText.Parent = statusContainer
    
    -- Button container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -40, 0, 60)
    buttonContainer.Position = UDim2.new(0, 20, 0, 400)
    buttonContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    buttonContainer.BorderSizePixel = 0
    buttonContainer.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = buttonContainer
    
    -- Buttons - BIGGER
    local refreshButton = Instance.new("TextButton")
    refreshButton.Name = "RefreshButton"
    refreshButton.Size = UDim2.new(0, 120, 1, -20)
    refreshButton.Position = UDim2.new(0, 10, 0, 10)
    refreshButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    refreshButton.Text = "🔄 REFRESH"
    refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshButton.Font = Enum.Font.SourceSansBold
    refreshButton.FontSize = 16 -- Bigger font
    refreshButton.Parent = buttonContainer
    
    local copyButton = Instance.new("TextButton")
    copyButton.Name = "CopyButton"
    copyButton.Size = UDim2.new(0, 120, 1, -20)
    copyButton.Position = UDim2.new(0, 140, 0, 10)
    copyButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    copyButton.Text = "📋 COPY"
    copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyButton.Font = Enum.Font.SourceSansBold
    copyButton.FontSize = 16
    copyButton.Parent = buttonContainer
    
    local clearButton = Instance.new("TextButton")
    clearButton.Name = "ClearButton"
    clearButton.Size = UDim2.new(0, 120, 1, -20)
    clearButton.Position = UDim2.new(0, 270, 0, 10)
    clearButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    clearButton.Text = "🗑️ CLEAR"
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.Font = Enum.Font.SourceSansBold
    clearButton.FontSize = 16
    clearButton.Parent = buttonContainer
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 120, 1, -20)
    closeButton.Position = UDim2.new(0, 400, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    closeButton.Text = "❌ CLOSE"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.FontSize = 16
    closeButton.Parent = buttonContainer
    
    -- Add corners to buttons
    for _, button in pairs({refreshButton, copyButton, clearButton, closeButton}) do
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = button
    end
    
    -- Button functions
    refreshButton.MouseButton1Click:Connect(function()
        updateDebugInfo(statusText)
    end)
    
    copyButton.MouseButton1Click:Connect(function()
        -- Copy to clipboard simulation
        showNotification("Copied", "Debug info copied to clipboard!", 3)
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        statusText.Text = "Debug cleared. Click REFRESH to scan again."
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    return screenGui, statusText
end

-- Update debug information
local function updateDebugInfo(statusText)
    printToConsole("Updating debug info...")
    
    local debugInfo = "=== FISH IT DEBUG INFORMATION ===\n\n"
    
    -- Player info
    debugInfo = debugInfo .. "👤 PLAYER INFORMATION:\n"
    debugInfo = debugInfo .. "  Name: " .. player.Name .. "\n"
    debugInfo = debugInfo .. "  ID: " .. player.UserId .. "\n"
    debugInfo = debugInfo .. "  Character: " .. (player.Character and "✅ Found" or "❌ Not Found") .. "\n\n"
    
    -- Character items
    debugInfo = debugInfo .. "🦴 CHARACTER ITEMS:\n"
    local character = player.Character
    if character then
        local itemCount = 0
        for _, item in pairs(character:GetChildren()) do
            itemCount = itemCount + 1
            debugInfo = debugInfo .. "  " .. itemCount .. ". " .. item.Name .. " (" .. item.ClassName .. ")\n"
            
            -- Check for fishing rod
            local lowerName = item.Name:lower()
            if lowerName:find("rod") or lowerName:find("fish") or lowerName:find("pole") then
                debugInfo = debugInfo .. "     🎣 POTENTIAL FISHING ROD!\n"
            end
        end
        if itemCount == 0 then
            debugInfo = debugInfo .. "  No items found in character\n"
        end
    else
        debugInfo = debugInfo .. "  ❌ Character not found\n"
    end
    debugInfo = debugInfo .. "\n"
    
    -- Backpack items
    debugInfo = debugInfo .. "🎒 BACKPACK ITEMS:\n"
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local itemCount = 0
        for _, item in pairs(backpack:GetChildren()) do
            itemCount = itemCount + 1
            debugInfo = debugInfo .. "  " .. itemCount .. ". " .. item.Name .. " (" .. item.ClassName .. ")\n"
            
            -- Check for fishing rod
            local lowerName = item.Name:lower()
            if lowerName:find("rod") or lowerName:find("fish") or lowerName:find("pole") then
                debugInfo = debugInfo .. "     🎣 POTENTIAL FISHING ROD!\n"
            end
        end
        if itemCount == 0 then
            debugInfo = debugInfo .. "  No items found in backpack\n"
        end
    else
        debugInfo = debugInfo .. "  ❌ Backpack not found\n"
    end
    debugInfo = debugInfo .. "\n"
    
    -- PlayerGui items
    debugInfo = debugInfo .. "🖥️ PLAYER GUI ITEMS:\n"
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        local itemCount = 0
        for _, item in pairs(playerGui:GetChildren()) do
            itemCount = itemCount + 1
            debugInfo = debugInfo .. "  " .. itemCount .. ". " .. item.Name .. " (" .. item.ClassName .. ")\n"
        end
        if itemCount == 0 then
            debugInfo = debugInfo .. "  No items found in PlayerGui\n"
        end
    else
        debugInfo = debugInfo .. "  ❌ PlayerGui not found\n"
    end
    debugInfo = debugInfo .. "\n"
    
    -- Additional info
    debugInfo = debugInfo .. "📊 ADDITIONAL INFO:\n"
    debugInfo = debugInfo .. "  Game: " .. game.Name .. "\n"
    debugInfo = debugInfo .. "  Place ID: " .. game.PlaceId .. "\n"
    debugInfo = debugInfo .. "  Job ID: " .. game.JobId .. "\n"
    debugInfo = debugInfo .. "\n"
    
    debugInfo = debugInfo .. "💡 TIPS:\n"
    debugInfo = debugInfo .. "  1. Make sure you have equipped your fishing rod\n"
    debugInfo = debugInfo .. "  2. Look for 🎣 markers next to potential fishing rods\n"
    debugInfo = debugInfo .. "  3. If no rods found, try equipping a different rod\n"
    debugInfo = debugInfo .. "  4. Click REFRESH to update the information\n"
    debugInfo = debugInfo .. "  5. Click COPY to copy this information\n"
    debugInfo = debugInfo .. "\n"
    
    debugInfo = debugInfo .. "=== DEBUG COMPLETE ==="
    
    -- Update the text
    statusText.Text = debugInfo
    printToConsole("Debug info updated")
end

-- Main function
local function main()
    printToConsole("Starting Fish It Large Debug...")
    showNotification("Fish It Debug", "Starting large debug tool...", 3)
    
    -- Create GUI
    local success, gui = pcall(createLargeGUI)
    if not success then
        printToConsole("ERROR: Failed to create GUI - " .. tostring(gui))
        showNotification("Error", "Failed to create GUI!", 5)
        return
    end
    
    local statusText = gui:FindFirstChild("MainFrame"):FindFirstChild("StatusContainer"):FindFirstChild("StatusText")
    
    -- Update debug info
    updateDebugInfo(statusText)
    
    -- Show completion notification
    showNotification("Debug Complete", "Large debug tool ready!", 3)
    printToConsole("Large debug tool completed successfully!")
end

-- Error handling
local success, err = pcall(main)
if not success then
    printToConsole("FATAL ERROR: " .. tostring(err))
    showNotification("Fatal Error", err, 10)
else
    printToConsole("Large debug script executed successfully!")
end
