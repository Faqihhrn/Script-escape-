--[[
  COBRAX AI - DELTA EXECUTOR SCRIPT
  TSUNAMI ESCAPE: BRAINROT EDITION
  Optimized for Delta Executor (Roblox)
  
  Fitur:
  - Auto farm / auto escape
  - ESP (lihat air dari jauh)
  - Speed boost
  - No clip (opsional)
--]]

-- ============== CONFIG ==============
local Config = {
    AutoEscape = true,      -- Auto lari ke tempat aman
    SpeedBoost = true,      -- Kecepatan lari 2x
    SpeedValue = 50,        -- Kecepatan (default 16)
    NoClip = false,         -- Tembus tembok (risiko ban)
    ESP = true,             -- Lihat tsunami dari jauh
    AutoJump = true,        -- Auto lompat di air
    TeleportToSafe = false, -- Langsung teleport (risiko tinggi)
}

-- ============== SERVICES ==============
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ============== UI TOGGLE (DRAW ON SCREEN) ==============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CobraX_UI"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 220, 0, 280)
mainFrame.Position = UDim2.new(0, 10, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 200)

local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🐍 COBRAX TSUNAMI ESCAPE"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

local function makeButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(0, 255, 200)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

makeButton("✅ Auto Escape: ON", 40, function()
    Config.AutoEscape = not Config.AutoEscape
    btn.Text = Config.AutoEscape and "✅ Auto Escape: ON" or "❌ Auto Escape: OFF"
end)

makeButton("⚡ Speed Boost: ON", 80, function()
    Config.SpeedBoost = not Config.SpeedBoost
    btn2.Text = Config.SpeedBoost and "⚡ Speed Boost: ON" or "⚡ Speed Boost: OFF"
    if Config.SpeedBoost then
        humanoid.WalkSpeed = Config.SpeedValue
    else
        humanoid.WalkSpeed = 16
    end
end)

makeButton("👁️ ESP: ON", 120, function()
    Config.ESP = not Config.ESP
    btn3.Text = Config.ESP and "👁️ ESP: ON" or "👁️ ESP: OFF"
end)

makeButton("🚪 No Clip: OFF", 160, function()
    Config.NoClip = not Config.NoClip
    btn4.Text = Config.NoClip and "🚪 No Clip: ON" or "🚪 No Clip: OFF"
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(0.9, 0, 0, 40)
statusLabel.Position = UDim2.new(0.05, 0, 0, 210)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
statusLabel.Text = "Status: Ready"
statusLabel.TextWrapped = true
statusLabel.Font = Enum.Font.Gotham

-- ============== SPEED BOOST HANDLER ==============
if Config.SpeedBoost then
    humanoid.WalkSpeed = Config.SpeedValue
end

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    if Config.SpeedBoost then
        humanoid.WalkSpeed = Config.SpeedValue
    end
end)

-- ============== FIND SAFE ZONE (TEMPAT TERTINGGI) ==============
local function findSafeZone()
    local highest = nil
    local highestY = -1000
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:find("Safe") or part.Name:find("Zone") or part.Name:find("Platform") then
            local yPos = part.Position.Y + part.Size.Y/2
            if yPos > highestY then
                highestY = yPos
                highest = part
            end
        end
    end
    -- fallback: cari part tertinggi
    if not highest then
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Anchored and part.Position.Y > highestY then
                highestY = part.Position.Y
                highest = part
            end
        end
    end
    return highest, highestY
end

-- ============== AUTO ESCAPE LOGIC ==============
local function autoEscape()
    if not Config.AutoEscape then return end
    local safeZone, safeY = findSafeZone()
    if safeZone and humanoid and character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local distance = (safeZone.Position - hrp.Position).Magnitude
        
        -- Kalo air udah deket atau posisi player terlalu rendah
        local waterLevel = 0
        for _, water in ipairs(workspace:GetDescendants()) do
            if water:IsA("Part") and (water.Name == "TsunamiWave" or water.Name == "WaterBase") then
                waterLevel = math.max(waterLevel, water.Position.Y + water.Size.Y/2)
            end
        end
        
        if hrp.Position.Y < waterLevel + 5 or distance > 50 then
            -- Lari ke safe zone
            local direction = (safeZone.Position - hrp.Position).Unit
            local newPos = hrp.Position + direction * 10
            hrp.CFrame = CFrame.new(newPos, safeZone.Position)
            statusLabel.Text = "🏃 ESCAPING TO SAFE ZONE..."
        else
            statusLabel.Text = "✅ SAFE ZONE REACHED"
        end
    end
end

-- ============== ESP (LIHAT TSUNAMI) ==============
local espObjects = {}
local function createESP(targetPart, color)
    if not Config.ESP then
        for _, obj in pairs(espObjects) do
            obj:Destroy()
        end
        espObjects = {}
        return
    end
    
    -- Bersihkan ESP lama
    for _, obj in pairs(espObjects) do
        obj:Destroy()
    end
    espObjects = {}
    
    for _, water in ipairs(workspace:GetDescendants()) do
        if water:IsA("Part") and (water.Name == "TsunamiWave" or water.Name == "WaterBase") then
            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = water
            box.Size = water.Size
            box.Color3 = color or Color3.fromRGB(0, 100, 255)
            box.Transparency = 0.5
            box.ZIndex = 10
            box.AlwaysOnTop = true
            box.Parent = player.PlayerGui
            table.insert(espObjects, box)
            
            local outline = Instance.new("SelectionBox")
            outline.Adornee = water
            outline.Color3 = Color3.fromRGB(0, 200, 255)
            outline.LineThickness = 0.1
            outline.Transparency = 0.7
            outline.Parent = player.PlayerGui
            table.insert(espObjects, outline)
        end
    end
end

-- ============== NO CLIP (TELEPORT THROUGH WALLS) ==============
RunService.Stepped:Connect(function()
    if Config.NoClip and character and character:FindFirstChild("HumanoidRootPart") then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- ============== AUTO JUMP DI AIR ==============
RunService.RenderStepped:Connect(function()
    if Config.AutoJump and humanoid and character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, water in ipairs(workspace:GetDescendants()) do
                if water:IsA("Part") and (water.Name == "TsunamiWave" or water.Name == "WaterBase") then
                    local waterTop = water.Position.Y + water.Size.Y/2
                    if hrp.Position.Y < waterTop + 3 and hrp.Position.Y > waterTop - 2 then
                        humanoid.Jump = true
                    end
                end
            end
        end
    end
end)

-- ============== TELEPORT TO SAFE ZONE ==============
local function teleportToSafe()
    local safeZone, _ = findSafeZone()
    if safeZone and character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        hrp.CFrame = CFrame.new(safeZone.Position + Vector3.new(0, 5, 0))
        statusLabel.Text = "✨ TELEPORTED TO SAFE ZONE!"
    else
        statusLabel.Text = "⚠️ SAFE ZONE NOT FOUND!"
    end
end

-- tombol teleport (opsional)
makeButton("✨ TELEPORT TO SAFE", 250, teleportToSafe)

-- ============== MAIN LOOP ==============
spawn(function()
    while wait(0.5) do
        autoEscape()
        if Config.ESP then
            createESP()
        end
    end
end)

-- ============== NOTIFIKASI AWAL ==============
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🐍 COBRAX AI",
    Text = "Delta Script Loaded! Tsunami Escape Active.",
    Duration = 3
})

print("🔥 COBRAX TSUNAMAI ESCAPE SCRIPT LOADED 🔥")
print("💀 GUI ada di pojok kiri atas")
print("⚡ Auto escape, speed boost, ESP aktif")

-- ============== DRAG UI (optional) ==============
local dragging = false
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
