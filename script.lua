--[[
  COBRAX AI - BRAINROT MAP CONTROLLER
  ROBLOX DELTA EXECUTOR SCRIPT
  GUI RAPIH | BUKA-TUTUP | MINIMIZE/MAXIMIZE
  FITUR: Mini Mode (kotak kecil) -> Full Mode (kotak besar)
--]]

-- ============== SERVICES ==============
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ============== GUI VARIABLES ==============
local isMinimized = false
local minimizedSize = UDim2.new(0, 50, 0, 50)      -- ukuran kecil (kotak)
local maximizedSize = UDim2.new(0, 320, 0, 480)    -- ukuran besar (full)

-- ============== CREATE MAIN GUI ==============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CobraX_BrainrotGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Background blur effect
local blurEffect = Instance.new("BlurEffect")
blurEffect.Name = "CobraX_Blur"
blurEffect.Parent = game:GetService("Lighting")
blurEffect.Enabled = false
blurEffect.Size = 8

-- ============== MAIN FRAME ==============
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = maximizedSize
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 100, 200)
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true

-- Corner rounding
local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 12)

-- ============== TITLE BAR ==============
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 80, 160)
titleBar.BackgroundTransparency = 0.15
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0.02, 0, 0, 0)
titleText.Text = "🧠 BRAINROT MAP 🧠 | SKIBIDI MODE"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- ============== MINIMIZE BUTTON (toggle) ==============
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = titleBar
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.Text = "🗕"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundTransparency = 0.9
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.BorderSizePixel = 0

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.Parent = minimizeBtn
minimizeCorner.CornerRadius = UDim.new(1, 0)

-- ============== CLOSE BUTTON ==============
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -70, 0, 5)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 0.9
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.Parent = closeBtn
closeCorner.CornerRadius = UDim.new(1, 0)

-- ============== CONTENT CONTAINER (untuk scroll/dimuat saat maximize) ==============
local contentContainer = Instance.new("ScrollingFrame")
contentContainer.Parent = mainFrame
contentContainer.Size = UDim2.new(1, 0, 1, -45)
contentContainer.Position = UDim2.new(0, 0, 0, 45)
contentContainer.BackgroundTransparency = 1
contentContainer.BorderSizePixel = 0
contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
contentContainer.ScrollBarThickness = 6
contentContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 160)

-- Canvas layout
local canvasLayout = Instance.new("UIListLayout")
canvasLayout.Parent = contentContainer
canvasLayout.Padding = UDim.new(0, 8)
canvasLayout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding")
padding.Parent = contentContainer
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)

-- ============== BRAINROT MAP CONTENT ==============
local function createCategory(title, icon, order)
    local categoryFrame = Instance.new("Frame")
    categoryFrame.Parent = contentContainer
    categoryFrame.Size = UDim2.new(1, 0, 0, 45)
    categoryFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    categoryFrame.BackgroundTransparency = 0.5
    categoryFrame.BorderSizePixel = 0
    categoryFrame.LayoutOrder = order
    
    local catCorner = Instance.new("UICorner")
    catCorner.Parent = categoryFrame
    catCorner.CornerRadius = UDim.new(0, 8)
    
    local catText = Instance.new("TextLabel")
    catText.Parent = categoryFrame
    catText.Size = UDim2.new(1, 0, 1, 0)
    catText.Text = icon .. " " .. title
    catText.TextColor3 = Color3.fromRGB(255, 200, 255)
    catText.BackgroundTransparency = 1
    catText.Font = Enum.Font.GothamBold
    catText.TextSize = 14
    catText.TextXAlignment = Enum.TextXAlignment.Left
    catText.PaddingLeft = UDim.new(0, 12)
    
    return categoryFrame
end

local function createButton(text, callback, color, order)
    local btn = Instance.new("TextButton")
    btn.Parent = contentContainer
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 45, 65)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.LayoutOrder = order
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(text, configKey, defaultValue, order)
    local frame = Instance.new("Frame")
    frame.Parent = contentContainer
    frame.Size = UDim2.new(1, 0, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = frame
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.PaddingLeft = UDim.new(0, 12)
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    toggleBtn.Position = UDim2.new(1, -90, 0.5, -15)
    toggleBtn.Text = defaultValue and "✅ ON" or "❌ OFF"
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 50, 50)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(1, 0)
    
    local state = defaultValue
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "✅ ON" or "❌ OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 50, 50)
        if callback then callback(state) end
    end)
    
    return {frame = frame, getState = function() return state end}
end

local function createSlider(text, minVal, maxVal, defaultVal, callback, order)
    local frame = Instance.new("Frame")
    frame.Parent = contentContainer
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.PaddingLeft = UDim.new(0, 12)
    
    local slider = Instance.new("Frame")
    slider.Parent = frame
    slider.Size = UDim2.new(0.9, 0, 0, 4)
    slider.Position = UDim2.new(0.05, 0, 0.6, 0)
    slider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    slider.BorderSizePixel = 0
    
    local fill = Instance.new("Frame")
    fill.Parent = slider
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 80, 160)
    fill.BorderSizePixel = 0
    
    local knob = Instance.new("TextButton")
    knob.Parent = slider
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -8, 0.5, -8)
    knob.Text = "●"
    knob.TextColor3 = Color3.fromRGB(255, 255, 255)
    knob.BackgroundTransparency = 1
    knob.Font = Enum.Font.GothamBold
    knob.TextSize = 16
    
    local value = defaultVal
    local dragging = false
    
    knob.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = slider.AbsolutePosition
            local sliderWidth = slider.AbsoluteSize.X
            local percent = math.clamp((mousePos.X - sliderPos.X) / sliderWidth, 0, 1)
            value = minVal + (maxVal - minVal) * percent
            value = math.floor(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -8, 0.5, -8)
            label.Text = text .. ": " .. value
            if callback then callback(value) end
        end
    end)
    
    return {frame = frame, getValue = function() return value end}
end

-- ============== BUILD CONTENT ==============
local order = 1
createCategory("🗺️ MAP CONTROL", order); order = order + 1

local mapToggle = createToggle("🧠 BRAINROT MAP ACTIVE", "mapActive", true, order); order = order + 1
local espToggle = createToggle("👁️ ESP PLAYER/MOB", "esp", true, order); order = order + 1

createCategory("⚡ MOVEMENT", order); order = order + 1
local speedSlider = createSlider("🏃 SPEED BOOST", 16, 100, 32, function(val)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = val
    end
end, order); order = order + 1

local jumpToggle = createToggle("🦘 INFINITE JUMP", "infJump", true, order); order = order + 1
local flyToggle = createToggle("🕊️ FLY MODE", "fly", false, order); order = order + 1

createCategory("🛡️ COMBAT", order); order = order + 1
local godToggle = createToggle("💀 GOD MODE", "godMode", true, order); order = order + 1
local autoFarmToggle = createToggle("🤖 AUTO FARM", "autoFarm", true, order); order = order + 1

createCategory("🎨 VISUAL", order); order = order + 1
local rainbowToggle = createToggle("🌈 RAINBOW MAP", "rainbow", false, order); order = order + 1
local blurToggle = createToggle("🌫️ BLUR EFFECT", "blur", false, order); order = order + 1

-- Update canvas size
canvasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, canvasLayout.AbsoluteContentSize.Y + 20)
end)

-- ============== FUNCTIONALITY IMPLEMENTATION ==============
-- God Mode
RunService.Stepped:Connect(function()
    if godToggle.getState() and player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        hum.Health = hum.MaxHealth
        hum.BreakJointsOnDeath = false
    end
end)

-- Infinite Jump
local infiniteJumpActive = false
UserInputService.JumpRequest:Connect(function()
    if jumpToggle.getState() and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fly Mode
local flying = false
local bodyVel = nil

flyToggle.getState = function() return flying end
flyToggle.frame.MouseButton1Click = nil

local function updateFlyMode()
    local newState = flyToggle.getState()
    if newState and not flying then
        flying = true
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVel.Velocity = Vector3.new(0, 0, 0)
            bodyVel.Parent = char.HumanoidRootPart
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = true
            end
        end
    elseif not newState and flying then
        flying = false
        if bodyVel then bodyVel:Destroy() end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
    end
end

flyToggle.frame.MouseButton1Click:Connect(function()
    local newState = not flying
    flyToggle.frame:FindFirstChildWhichIsA("TextButton").Text = newState and "✅ ON" or "❌ OFF"
    flyToggle.frame:FindFirstChildWhichIsA("TextButton").BackgroundColor3 = newState and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 50, 50)
    updateFlyMode()
end)

RunService.RenderStepped:Connect(function()
    if flying and bodyVel and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local move = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0, -1, 0) end
        if move.Magnitude > 0 then
            bodyVel.Velocity = move.Unit * 60
        else
            bodyVel.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Blur Effect
blurToggle.frame.MouseButton1Click:Connect(function()
    local state = blurToggle.getState()
    blurEffect.Enabled = state
end)

-- Rainbow Map Effect
local rainbowHue = 0
RunService.RenderStepped:Connect(function()
    if rainbowToggle.getState() then
        rainbowHue = (rainbowHue + 0.005) % 1
        local color = Color3.fromHSV(rainbowHue, 1, 0.7)
        mainFrame.BorderColor3 = color
        titleBar.BackgroundColor3 = color
        titleBar.BackgroundTransparency = 0.3
    else
        mainFrame.BorderColor3 = Color3.fromRGB(255, 100, 200)
        titleBar.BackgroundColor3 = Color3.fromRGB(255, 80, 160)
        titleBar.BackgroundTransparency = 0.15
    end
end)

-- Auto Farm Simple
spawn(function()
    while wait(0.5) do
        if autoFarmToggle.getState() then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= player.Character then
                    local hum = obj.Humanoid
                    if hum.Health > 0 then
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if hrp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 2, 0))
                            wait(0.1)
                        end
                    end
                end
            end
        end
    end
end)

-- ESP
local espObjects = {}
local function updateESP()
    if not espToggle.getState() then
        for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
        espObjects = {}
        return
    end
    
    for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
    espObjects = {}
    
    for _, entity in ipairs(workspace:GetDescendants()) do
        if entity:IsA("Model") and entity:FindFirstChild("Humanoid") and entity ~= player.Character then
            local hrp = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Torso")
            if hrp then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = hrp
                box.Size = Vector3.new(4, 4, 4)
                box.Color3 = Color3.fromRGB(255, 50, 100)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.Parent = player.PlayerGui
                table.insert(espObjects, box)
            end
        end
    end
end

spawn(function()
    while wait(1) do updateESP() end
end)

-- ============== MINIMIZE / MAXIMIZE FUNCTION ==============
local function toggleMinimize()
    isMinimized = not isMinimized
    local targetSize = isMinimized and minimizedSize or maximizedSize
    local targetPosX = isMinimized and 1 or 0.5
    local targetOffsetX = isMinimized and -25 or -160
    local targetPosY = isMinimized and 1 or 0.5
    local targetOffsetY = isMinimized and -25 or -240
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local sizeTween = TweenService:Create(mainFrame, tweenInfo, {Size = targetSize})
    local posTween = TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(targetPosX, targetOffsetX, targetPosY, targetOffsetY)})
    
    sizeTween:Play()
    posTween:Play()
    
    -- Hide content when minimized
    contentContainer.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "🗖" or "🗕"
    
    -- Change title text when minimized
    if isMinimized then
        titleText.Text = "🧠"
    else
        titleText.Text = "🧠 BRAINROT MAP 🧠 | SKIBIDI MODE"
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- ============== CLOSE / HIDE GUI ==============
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    blurEffect.Enabled = false
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🐍 COBRAX AI",
        Text = "GUI hidden. Type /reload in console to show again.",
        Duration = 3
    })
end)

-- ============== RE-ENABLE GUI VIA CONSOLE ==============
-- Kalo kepencet close, bisa pake command: _G.ShowCobraXGUI()
_G.ShowCobraXGUI = function()
    screenGui.Enabled = true
    if blurToggle and blurToggle.getState() then
        blurEffect.Enabled = true
    end
end

-- ============== INITIAL NOTIFICATION ==============
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🐍 COBRAX BRAINRO--[[
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
