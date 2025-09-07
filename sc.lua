-- Tambahkan nama-nama rod spesifik
local function hasFishingRod()
    local character = player.Character
    if not character then return false end
    
    -- List semua kemungkinan nama rod
    local rodNames = {
        "Rod", "Fishing", "Basic", "Advanced", "Pro", "Master", 
        "Super", "Ultra", "Legendary", "Mythic", "God", "Divine",
        "Starter", "Wooden"
    }
    
    -- Check character
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            for _, rodName in pairs(rodNames) do
                if item.Name:find(rodName) then
                    return true
                end
            end
        end
    end
    
    -- Check backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                for _, rodName in pairs(rodNames) do
                    if item.Name:find(rodName) then
                        return true
                    end
                end
            end
        end
    end
    
    return false
end
