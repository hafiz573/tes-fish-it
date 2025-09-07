-- Fish It Simple Debug Script
-- Created by AI Assistant
-- Will show notifications and simple output

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

-- Simple GUI creation
local function createSimpleGUI()
    printToConsole("Creating GUI...")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FishItSimpleDebug"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔍 Fish It Debug"
    title.TextColor3 = Color3.fromRGB(255, 255, 100)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.Parent = mainFrame
    
    -- Status text
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, -20, 0, 100)
    statusText.Position = UDim2.new(0, 10, 0, 50)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Checking player items..."
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextScaled = true
    statusText.Font = Enum.Font.SourceSans
    statusText.TextWrapped = true
    statusText.Parent = mainFrame
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(1, -20, 0, 30)
    closeButton.Position = UDim2.new(0, 10, 0, 160)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "Close"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    return screenGui, statusText
end

-- Main function
local function main()
    printToConsole("Starting Fish It Simple Debug...")
    showNotification("Fish It Debug", "Starting debug script...", 3)
    
    -- Create GUI
    local success, gui = pcall(createSimpleGUI)
    if not success then
        printToConsole("ERROR: Failed to create GUI - " .. tostring(gui))
        showNotification("Error", "Failed to create GUI!", 5)
        return
    end
    
    local statusText = gui:FindFirstChild("MainFrame"):FindFirstChild("StatusText")
    
    -- Check player
    printToConsole("Player: " .. player.Name)
    statusText.Text = "Player: " .. player.Name .. "\n"
    
    -- Check character
    local character = player.Character
    if character then
        printToConsole("Character found!")
        statusText.Text = statusText.Text .. "✅ Character found\n"
        
        -- List all character items
        statusText.Text = statusText.Text .. "Character items:\n"
        for _, item in pairs(character:GetChildren()) do
            printToConsole("Character item: " .. item.Name .. " (" .. item.ClassName .. ")")
            statusText.Text = statusText.Text .. "  • " .. item.Name .. " (" .. item.ClassName .. ")\n"
            
            -- Check if it might be a fishing rod
            local lowerName = item.Name:lower()
            if lowerName:find("rod") or lowerName:find("fish") or lowerName:find("pole") then
                printToConsole("🎣 POTENTIAL FISHING ROD: " .. item.Name)
                statusText.Text = statusText.Text .. "    🎣 POTENTIAL FISHING ROD!\n"
            end
        end
    else
        printToConsole("Character NOT found!")
        statusText.Text = statusText.Text .. "❌ Character NOT found!\n"
    end
    
    -- Check backpack
    statusText.Text = statusText.Text .. "\nBackpack items:\n"
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        printToConsole("Backpack found!")
        statusText.Text = statusText.Text .. "✅ Backpack found\n"
        
        for _, item in pairs(backpack:GetChildren()) do
            printToConsole("Backpack item: " .. item.Name .. " (" .. item.ClassName .. ")")
            statusText.Text = statusText.Text .. "  • " .. item.Name .. " (" .. item.ClassName .. ")\n"
            
            -- Check if it might be a fishing rod
            local lowerName = item.Name:lower()
            if lowerName:find("rod") or lowerName:find("fish") or lowerName:find("pole") then
                printToConsole("🎣 POTENTIAL FISHING ROD: " .. item.Name)
                statusText.Text = statusText.Text .. "    🎣 POTENTIAL FISHING ROD!\n"
            end
        end
    else
        printToConsole("Backpack NOT found!")
        statusText.Text = statusText.Text .. "❌ Backpack NOT found!\n"
    end
    
    -- Check PlayerGui
    statusText.Text = statusText.Text .. "\nPlayerGui items:\n"
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        printToConsole("PlayerGui found!")
        statusText.Text = statusText.Text .. "✅ PlayerGui found\n"
        
        for _, item in pairs(playerGui:GetChildren()) do
            printToConsole("PlayerGui item: " .. item.Name .. " (" .. item.ClassName .. ")")
            statusText.Text = statusText.Text .. "  • " .. item.Name .. " (" .. item.ClassName .. ")\n"
        end
    else
        printToConsole("PlayerGui NOT found!")
        statusText.Text = statusText.Text .. "❌ PlayerGui NOT found!\n"
    end
    
    -- Finish
    statusText.Text = statusText.Text .. "\n✅ Debug complete!"
    printToConsole("Debug complete!")
    showNotification("Debug Complete", "Check the GUI and console for results!", 5)
end

-- Error handling
local success, err = pcall(main)
if not success then
    printToConsole("FATAL ERROR: " .. tostring(err))
    showNotification("Fatal Error", err, 10)
else
    printToConsole("Script executed successfully!")
    showNotification("Success", "Debug script completed!", 3)
end
