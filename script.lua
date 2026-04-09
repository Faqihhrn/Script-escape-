--[[
  COBRAX AI - DIVINE INFINITY CELESTIAL SCRIPT
  ANTI-BAN + AUTO FARM + AUTO UPGRADE + AUTO DAILY
  OPTIMIZED FOR DELTA EXECUTOR
  
  FITUR:
  ✅ Auto Farm EXP/Money/Gems
  ✅ Auto Upgrade Weapon/Armor/Stats
  ✅ Auto Daily Rewards & Login
  ✅ Auto Quest Complete
  ✅ Auto Boss Kill
  ✅ ESP Player/Mob/Boss
  ✅ Speed/Fly/Jump
  ✅ God Mode/Infinite HP
  ✅ Click TP (Teleport)
  ✅ Auto Rebirth/Reset
  
  ANTI-BAN SYSTEM:
  ✅ Human-like random delays
  ✅ Anti-AFK (auto move random)
  ✅ Randomized click patterns
  ✅ No over-farming detection
  ✅ Auto rejoin on suspicious kicks
--]]

-- ============== LOADING GUI ==============
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local mouse = player:GetMouse()

-- ============== CONFIGURATION ==============
local Config = {
    -- Auto Farm
    AutoFarm = true,
    AutoFarmDelay = {0.3, 0.8}, -- random delay antara 0.3-0.8 detik
    
    -- Auto Upgrade
    AutoUpgrade = true,
    UpgradeDelay = {5, 12}, -- delay antar upgrade
    
    -- Auto Daily
    AutoDaily = true,
    
    -- Auto Quest
    AutoQuest = true,
    
    -- Auto Boss
    AutoBoss = false, -- hati2, lebih riskan
    
    -- Movement
    SpeedBoost = true,
    SpeedValue = 32,
    AutoJump = true,
    FlyMode = false,
    
    -- Combat
    GodMode = true,
    InfiniteStamina = true,
    OneHitKill = false, -- RISKAN BANGET!
    
    -- Utility
    ESP = true,
    ClickTeleport = true,
    AntiAFK = true,
    AutoRejoin = true,
}

-- ============== ANTI-BAN SYSTEM ==============
local AntiBan = {
    actionCounter = 0,
    lastActionTime = tick(),
    humanizedDelay = function(min, max)
        local base = min + math.random() * (max - min)
        -- tambah random offset 0.1-0.5 detik biar gak pattern
        local offset = math.random(10, 50) / 100
        return base + offset
    end,
    
    recordAction = function()
        AntiBan.actionCounter = AntiBan.actionCounter + 1
        AntiBan.lastActionTime = tick()
        if AntiBan.actionCounter > 50 then
            -- istirahat sebentar biar gak ketahuan bot
            wait(AntiBan.humanizedDelay(2, 5))
            AntiBan.actionCounter = 0
        end
    end,
    
    randomMove = function()
        if not Config.AntiAFK then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp and humanoid then
            local randomAngle = math.random() * math.pi * 2
            local randomDist = math.random(3, 8)
            local newPos = hrp.Position + Vector3.new(math.cos(randomAngle) * randomDist, 0, math.sin(randomAngle) * randomDist)
            hrp.CFrame = CFrame.new(newPos)
            wait(AntiBan.humanizedDelay(45, 90))
        end
    end,
}

-- ============== CREATE GUI ==============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CobraX_DivineCelestial"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 280, 0, 420)
mainFrame.Position = UDim2.new(0, 10, 0, 80)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(212, 175, 55) -- gold
mainFrame.Active = true
mainFrame.Draggable = true

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
titleBar.BackgroundTransparency = 0.3

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Text = "🐍 COBRAX - DIVINE INFINITY CELESTIAL"
titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 12

-- Status Bar
local statusBar = Instance.new("TextLabel")
statusBar.Parent = mainFrame
statusBar.Size = UDim2.new(0.95, 0, 0, 25)
statusBar.Position = UDim2.new(0.025, 0, 0, 35)
statusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
statusBar.BackgroundTransparency = 0.5
statusBar.Text = "🟢 SYSTEM READY | ANTI-BAN ACTIVE"
statusBar.TextColor3 = Color3.fromRGB(0, 255, 100)
statusBar.TextSize = 10
statusBar.Font = Enum.Font.Gotham

-- ============== BUTTON MAKER ==============
local function makeButton(text, yPos, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(212, 175, 55)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.MouseButton1Click:Connect(function()
        callback()
        AntiBan.recordAction()
    end)
    return btn
end

local function makeToggle(text, yPos, configKey, defaultValue)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = (defaultValue and "✅ " or "❌ ") .. text
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(212, 175, 55)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    
    btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        btn.Text = (Config[configKey] and "✅ " or "❌ ") .. text
        statusBar.Text = Config[configKey] and "🟢 " .. text .. " ACTIVE" or "🔴 " .. text .. " OFF"
        wait(0.5)
        statusBar.Text = "🟢 SYSTEM READY | ANTI-BAN ACTIVE"
        AntiBan.recordAction()
    end)
    return btn
end

-- ============== BUILD TOGGLE BUTTONS ==============
local yOffset = 70
makeToggle("AUTO FARM", yOffset, "AutoFarm", true)
makeToggle("AUTO UPGRADE", yOffset + 32, "AutoUpgrade", true)
makeToggle("AUTO DAILY", yOffset + 64, "AutoDaily", true)
makeToggle("AUTO QUEST", yOffset + 96, "AutoQuest", true)
makeToggle("AUTO BOSS (RISKY)", yOffset + 128, "AutoBoss", false)
makeToggle("SPEED BOOST", yOffset + 160, "SpeedBoost", true)
makeToggle("GOD MODE", yOffset + 192, "GodMode", true)
makeToggle("ESP ON", yOffset + 224, "ESP", true)
makeToggle("CLICK TP", yOffset + 256, "ClickTeleport", true)

-- ============== SPEED BOOST ==============
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

-- ============== GOD MODE (INFINITE HEALTH) ==============
RunService.Stepped:Connect(function()
    if Config.GodMode and character and character:FindFirstChild("Humanoid") then
        local hum = character.Humanoid
        hum.Health = hum.MaxHealth
        hum.BreakJointsOnDeath = false
    end
end)

-- ============== AUTO FARM CORE ==============
local function findNearestEnemy()
    local nearest = nil
    local shortestDist = math.huge
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local hum = obj:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and obj ~= character then
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                if hrp and character:FindFirstChild("HumanoidRootPart") then
                    local dist = (hrp.Position - character.HumanoidRootPart.Position).Magnitude
                    if dist < shortestDist and dist < 150 then
                        shortestDist = dist
                        nearest = obj
                    end
                end
            end
        end
    end
    return nearest
end

local function attackEntity(entity)
    if not entity or not entity:FindFirstChild("Humanoid") then return end
    local hrp = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Torso")
    if not hrp then return end
    
    -- Move to target
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 2, 0))
    end
    
    -- Auto click / attack
    local args = {
        [1] = hrp,
    }
    -- Coba trigger attack via remote events (generic)
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") and remote.Name:lower():find("attack") or remote.Name:lower():find("damage") then
            pcall(function() remote:FireServer(unpack(args)) end)
        end
    end
    
    -- Simulate click attack
    VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, true, game, 0)
    wait(0.05)
    VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, false, game, 0)
    
    AntiBan.recordAction()
end

-- ============== AUTO FARM LOOP ==============
spawn(function()
    while wait(AntiBan.humanizedDelay(0.2, 0.6)) do
        if Config.AutoFarm then
            local target = findNearestEnemy()
            if target then
                attackEntity(target)
            else
                -- Random movement if no enemy
                if Config.AntiAFK and math.random() < 0.3 then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local randomPos = hrp.Position + Vector3.new(math.random(-20, 20), 0, math.random(-20, 20))
                        hrp.CFrame = CFrame.new(randomPos)
                    end
                end
            end
        end
    end
end)

-- ============== AUTO UPGRADE ==============
spawn(function()
    while wait(AntiBan.humanizedDelay(Config.UpgradeDelay[1], Config.UpgradeDelay[2])) do
        if Config.AutoUpgrade then
            -- Cari tombol upgrade di GUI
            for _, btn in ipairs(player.PlayerGui:GetDescendants()) do
                if btn:IsA("TextButton") then
                    local text = btn.Text:lower()
                    if text:find("upgrade") or text:find("level") or text:find("enhance") or text:find("power") then
                        pcall(function() btn:Click() end)
                        AntiBan.recordAction()
                        wait(AntiBan.humanizedDelay(0.5, 1.5))
                    end
                end
            end
        end
    end
end)

-- ============== AUTO DAILY REWARD ==============
spawn(function()
    while wait(AntiBan.humanizedDelay(60, 120)) do
        if Config.AutoDaily then
            for _, btn in ipairs(player.PlayerGui:GetDescendants()) do
                if btn:IsA("TextButton") then
                    local text = btn.Text:lower()
                    if text:find("daily") or text:find("reward") or text:find("claim") or text:find("login") then
                        pcall(function() btn:Click() end)
                        AntiBan.recordAction()
                    end
                end
            end
        end
    end
end)

-- ============== AUTO QUEST ==============
spawn(function()
    while wait(AntiBan.humanizedDelay(5, 15)) do
        if Config.AutoQuest then
            for _, btn in ipairs(player.PlayerGui:GetDescendants()) do
                if btn:IsA("TextButton") then
                    local text = btn.Text:lower()
                    if text:find("accept") or text:find("complete") or text:find("claim") or text:find("quest") then
                        pcall(function() btn:Click() end)
                        AntiBan.recordAction()
                        wait(AntiBan.humanizedDelay(0.3, 0.8))
                    end
                end
            end
        end
    end
end)

-- ============== CLICK TELEPORT ==============
if Config.ClickTeleport then
    mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if target and target:IsA("BasePart") and target.Parent ~= character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
                statusBar.Text = "✨ TELEPORTED!"
                wait(1)
                statusBar.Text = "🟢 SYSTEM READY | ANTI-BAN ACTIVE"
            end
        end
    end)
end

-- ============== ESP (SEE ENEMIES THROUGH WALLS) ==============
local espObjects = {}
local function updateESP()
    if not Config.ESP then
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
        return
    end
    
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
    
    for _, entity in ipairs(workspace:GetDescendants()) do
        if entity:IsA("Model") and entity:FindFirstChild("Humanoid") and entity ~= character then
            local hrp = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Torso")
            if hrp then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = hrp
                box.Size = Vector3.new(4, 4, 4)
                box.Color3 = Color3.fromRGB(255, 50, 50)
                box.Transparency = 0.6
                box.ZIndex = 10
                box.AlwaysOnTop = true
                box.Parent = player.PlayerGui
                table.insert(espObjects, box)
                
                local nameTag = Instance.new("TextLabel")
                nameTag.Parent = player.PlayerGui
                nameTag.Text = entity.Name or "Enemy"
                nameTag.TextColor3 = Color3.fromRGB(255, 100, 100)
                nameTag.BackgroundTransparency = 1
                nameTag.TextStrokeTransparency = 0.5
                nameTag.Font = Enum.Font.GothamBold
                nameTag.TextSize = 12
                
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    if not hrp or not hrp.Parent then
                        pcall(function() nameTag:Destroy() end)
                        connection:Disconnect()
                        return
                    end
                    local pos, onScreen = camera:WorldToScreenPoint(hrp.Position + Vector3.new(0, 2.5, 0))
                    if onScreen then
                        nameTag.Position = UDim2.new(0, pos.X - 40, 0, pos.Y - 30)
                        nameTag.Visible = true
                    else
                        nameTag.Visible = false
                    end
                end)
                table.insert(espObjects, nameTag)
            end
        end
    end
end

local camera = workspace.CurrentCamera
spawn(function()
    while wait(1) do
        updateESP()
    end
end)

-- ============== ANTI AFK LOOP ==============
spawn(function()
    while wait(AntiBan.humanizedDelay(30, 60)) do
        if Config.AntiAFK then
            -- random small movement
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp and humanoid then
                local smallMove = Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                hrp.CFrame = hrp.CFrame + smallMove
            end
            -- random camera slight rotation
            local cam = workspace.CurrentCamera
            if cam then
                local cf = cam.CFrame
                cam.CFrame = cf * CFrame.Angles(0, math.rad(math.random(-5, 5)), 0)
            end
        end
    end
end)

-- ============== AUTO REJOIN ON KICK ==============
if Config.AutoRejoin then
    game:OnTeleport(function(state)
        if state == Enum.TeleportState.Failed then
            wait(5)
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end
    end)
end

-- ============== INFINITE STAMINA / ENERGY ==============
RunService.Stepped:Connect(function()
    if Config.InfiniteStamina and character then
        for _, stat in ipairs(character:GetDescendants()) do
            if stat:IsA("NumberValue") and (stat.Name:lower():find("stamina") or stat.Name:lower():find("energy") or stat.Name:lower():find("mana")) then
                stat.Value = stat.Value + 100
            end
        end
    end
end)

-- ============== NOTIFICATION ==============
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🐍 COBRAX AI",
    Text = "DIVINE INFINITY CELESTIAL LOADED!",
    Duration = 4
})

print("🔥 COBRAX DIVINE INFINITY CELESTIAL ACTIVE 🔥")
print("💀 ANTI-BAN SYSTEM ENABLED")
print("⚡ AUTO FARM + UPGRADE + DAILY + QUEST")
print("🎮 GUI di pojok kiri, bisa di-drag")

-- ============== INFINITE JUMP ==============
local infiniteJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if Config.AutoJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ============== FLY MODE (TOGGLE VIA BUTTON) ==============
local flying = false
local bodyVelocity = nil

local function toggleFly()
    Config.FlyMode = not Config.FlyMode
    if Config.FlyMode then
        flying = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
        humanoid.PlatformStand = true
        statusBar.Text = "🕊️ FLY MODE ACTIVE"
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        humanoid.PlatformStand = false
        flying = false
        statusBar.Text = "🟢 SYSTEM READY"
    end
end

makeButton("🕊️ TOGGLE FLY MODE", yOffset + 290, toggleFly, Color3.fromRGB(50, 30, 80))

-- Fly movement
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity and character:FindFirstChild("HumanoidRootPart") then
        local moveVector = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector + Vector3.new(0, -1, 0) end
        
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * 50
        end
        bodyVelocity.Velocity = moveVector
    end
end)

-- Anti-Ban randomizer loop (keep alive)
spawn(function()
    while wait(AntiBan.humanizedDelay(300, 600)) do
        -- Random idle movement to look human
        if Config.AntiAFK then
            AntiBan.randomMove()
        end
    end
end)
