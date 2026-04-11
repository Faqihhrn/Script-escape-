```lua
--[[
    LILIL HUB | ESCAPE TSUNAMI BRAINROT EDITION
    Script Name: LILIL_HUB_V4.lua
    Game: Escape Tsunami (Roblox)
    Features: Auto Farm Brainrot | Secret Divine Infinity | Auto Teleport Base | Anti Ban | Anti Mati
    GUI Style: Horizontal Side Panel (Buka/Tutup)
    Executor: Delta / Arceus X / Codex
    Animasi ketika execute: ADA (kira-kira kaya brainrot dance)
    
    WUIDIH COBRAX MODE ON 🔥💀
--]]

--[[[ BRAINROT ANIMATION EXECUTE ]]--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local TweenService = game:GetService("TweenService")

-- SPIN BRAINROT ANIMATION
local function brainrotSpin()
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(360), 0)})
        tween:Play()
        game:GetService("Debris"):AddItem(tween, 3)
    end
end

-- PARTICLE BRAINROT
local function brainrotParticles()
    local part = Instance.new("Part")
    part.Size = Vector3.new(1,1,1)
    part.Anchored = true
    part.CFrame = hrp.CFrame
    part.BrickColor = BrickColor.new("Really red")
    part.Material = Enum.Material.Neon
    part.Parent = game:GetService("Workspace")
    game:GetService("Debris"):AddItem(part, 2)
end

brainrotSpin()
brainrotParticles()
game:GetService("StarterGui"):SetCore("SendNotification", {Title="LILIL HUB", Text="BRAINROT ACTIVATED 🔥", Duration=3})

--[[[ GUI KEREN SAMPING (BUKA TUTUP) ]]--
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LILIL_HUB_GUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 450)
mainFrame.Position = UDim2.new(0, -320, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 50, 100)
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Shadow
local shadow = Instance.new("UICorner")
shadow.CornerRadius = UDim.new(0, 12)
shadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
titleBar.BackgroundTransparency = 0.3
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "LILIL HUB | BRAINROT EDITION"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.Parent = titleBar

-- Toggle Button (Buka/Tutup)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 30, 1, 0)
toggleBtn.Position = UDim2.new(1, -35, 0, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = "◀"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = titleBar

local isOpen = false
local tweenOpen = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 0.5, -225)})
local tweenClose = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, -320, 0.5, -225)})

toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        tweenOpen:Play()
        toggleBtn.Text = "▶"
    else
        tweenClose:Play()
        toggleBtn.Text = "◀"
    end
end)

-- Scrolling Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 10)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.Parent = scrollFrame

--[[[ FUNGSI UTAMA ]]--
local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.BackgroundColor3 = color or Color3.fromRGB(255, 50, 100)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = false
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.Parent = scrollFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = scrollFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 30)
    toggleBtn.Position = UDim2.new(0.8, 0, 0.5, -15)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0,200,0) or Color3.fromRGB(100,100,100)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    toggleBtn.TextSize = 12
    local cornerBtn = Instance.new("UICorner")
    cornerBtn.CornerRadius = UDim.new(0, 15)
    cornerBtn.Parent = toggleBtn
    toggleBtn.Parent = frame
    
    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(100,100,100)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    callback(state)
    return toggleBtn
end

--[[[ AUTO FARM BRAINROT ]]--
local brainrotPart = nil
local brainrotFolder = workspace:FindFirstChild("Brainrot") or workspace:FindFirstChild("BrainRot") or workspace:FindFirstChild("BrainRots")
local brainrotList = {}

for _, v in pairs(workspace:GetDescendants()) do
    if v.Name:lower():match("brain") or v.Name:lower():match("rot") or v.Name:lower():match("point") then
        if v:IsA("BasePart") then
            table.insert(brainrotList, v)
        end
    end
end

if #brainrotList == 0 then
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():match("brain") then
            for _, part in pairs(v:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(brainrotList, part)
                end
            end
        end
    end
end

local brainrotTarget = nil
local farmEnabled = false

local function teleportToPart(part)
    if not part then return end
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    end
end

local function collectBrainrot()
    if not farmEnabled then return end
    local nearest = nil
    local dist = math.huge
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, part in pairs(brainrotList) do
        if part and part.Parent then
            local d = (hrp.Position - part.Position).Magnitude
            if d < dist then
                dist = d
                nearest = part
            end
        end
    end
    if nearest then
        teleportToPart(nearest)
    end
end

--[[[ SECRET DIVINE INFINITY ]]--
local divineEnabled = false
local divinePart = nil

for _, v in pairs(workspace:GetDescendants()) do
    if v.Name:lower():match("divine") or v.Name:lower():match("infinity") or v.Name:lower():match("secret") then
        if v:IsA("BasePart") or v:IsA("Model") then
            divinePart = v
            break
        end
    end
end

local function teleportToDivine()
    if divinePart then
        local targetCF = divinePart:IsA("Model") and divinePart.PrimaryPart and divinePart.PrimaryPart.CFrame or 
                         (divinePart:IsA("BasePart") and divinePart.CFrame)
        if targetCF then
            local hrp = Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = targetCF + Vector3.new(0, 3, 0)
                game:GetService("StarterGui"):SetCore("SendNotification", {Title="LILIL HUB", Text="Divine Infinity Collected! 🧠🔥", Duration=2})
            end
        end
    end
end

--[[[ AUTO TELEPORT TO BASE ]]--
local function teleportToBase()
    local base = workspace:FindFirstChild("Base") or workspace:FindFirstChild("SafeZone") or workspace:FindFirstChild("SpawnLocation")
    if not base then
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():match("base") or v.Name:lower():match("safe") then
                base = v
                break
            end
        end
    end
    if base then
        local targetPos = base:IsA("Model") and base.PrimaryPart and base.PrimaryPart.CFrame or 
                          (base:IsA("BasePart") and base.CFrame)
        if targetPos then
            local hrp = Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = targetPos + Vector3.new(0, 3, 0)
                game:GetService("StarterGui"):SetCore("SendNotification", {Title="LILIL HUB", Text="Teleported to Base!", Duration=2})
            end
        end
    end
end

--[[[ ANTI BAN + ANTI MATI ]]--
local antiBanEnabled = false
local antiMatiEnabled = false

-- Anti Ban: Prevent kick/ban by overriding remote events
if syn and syn.crypt then
    local oldMet = getrawmetatable(game)
    setreadonly(oldMet, false)
    local namecall = oldMet.__namecall
    oldMet.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and tostring(self):lower():match("ban") then
            return nil
        end
        if method == "InvokeServer" and tostring(self):lower():match("kick") then
            return nil
        end
        return namecall(self, ...)
    end)
    setreadonly(oldMet, true)
end

-- Anti Mati: Auto heal jika health rendah
local function antiMatiLoop()
    while antiMatiEnabled and task.wait(0.5) do
        local humanoid = Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health < 30 then
            humanoid.Health = humanoid.MaxHealth
            if Character:FindFirstChild("HumanoidRootPart") then
                Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            end
        end
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    end
end

--[[[ LOOP UTAMA AUTO FARM ]]--
task.spawn(function()
    while task.wait(0.2) do
        if farmEnabled then
            collectBrainrot()
        end
        if divineEnabled and divinePart then
            teleportToDivine()
            task.wait(1)
        end
    end
end)

--[[[ BUAT GUI ELEMENTS ]]--
createButton("🧠 AUTO FARM BRAINROT 🧠", Color3.fromRGB(255, 80, 120), function()
    farmEnabled = not farmEnabled
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="LILIL HUB", Text=farmEnabled and "Auto Farm ON" or "Auto Farm OFF", Duration=2})
end)

createButton("✨ TELEPORT TO SECRET DIVINE INFINITY ✨", Color3.fromRGB(200, 100, 255), function()
    teleportToDivine()
end)

createButton("🏠 TELEPORT TO BASE 🏠", Color3.fromRGB(100, 200, 255), function()
    teleportToBase()
end)

createButton("💀 COLLECT ALL BRAINROT (INSTANT) 💀", Color3.fromRGB(255, 50, 50), function()
    for _, part in pairs(brainrotList) do
        if part and part.Parent then
            teleportToPart(part)
            task.wait(0.05)
        end
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="LILIL HUB", Text="Brainrot Collected!", Duration=2})
end)

createToggle("🛡️ ANTI BAN (Bypass Kick)", false, function(state)
    antiBanEnabled = state
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="LILIL HUB", Text=state and "Anti Ban ACTIVE" or "Anti Ban OFF", Duration=2})
end)

createToggle("💖 ANTI MATI (Auto Heal)", false, function(state)
    antiMatiEnabled = state
    if state then
        task.spawn(antiMatiLoop)
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="LILIL HUB", Text=state and "Anti Mati ACTIVE" or "Anti Mati OFF", Duration=2})
end)

createButton("🔄 RESPAWN / FIX CHARACTER", Color3.fromRGB(255, 165, 0), function()
    if Character then
        Character.Humanoid.Health = 0
        task.wait(1)
        Character = LocalPlayer.CharacterAdded:Wait()
    end
end)

createButton("💀 DESTROY GUI", Color3.fromRGB(100, 100, 100), function()
    screenGui:Destroy()
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="LILIL HUB", Text="GUI Destroyed. Re-run script to restore.", Duration=3})
end)

-- Update canvas size
local function updateCanvas()
    task.wait(0.1)
    local size = uiList.AbsoluteContentSize
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, size.Y + 20)
end
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
updateCanvas()

-- Buka GUI sedikit awal
task.wait(0.5)
isOpen = true
tweenOpen:Play()
toggleBtn.Text = "▶"

-- Tambahan Brainrot Vibe
local hrpLoop = Character:FindFirstChild("HumanoidRootPart")
if hrpLoop then
    local spin = TweenService:Create(hrpLoop, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true), {CFrame = hrpLoop.CFrame * CFrame.Angles(0, math.rad(360), 0)})
    spin:Play()
end

game:GetService("StarterGui"):SetCore("SendNotification", {Title="LILIL HUB", Text="LOADED 🔥 BRAINROT MODE | AUTO FARM READY", Duration=5})

--[[[ INFO ]]--
print("LILIL HUB | ESCAPE TSUNAMI | BRAINROT EDITION")
print("Auto Farm Brainrot, Divine Infinity, Auto Base, Anti Ban, Anti Mati")
print("Made for Delta Executor | COBRAX STYLE")

-- Tambahan effect keren biar makin brainrot
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://9120386534" -- brainrot sound effect
sound.Volume = 0.5
sound.Parent = Character
sound:Play()
game:GetService("Debris"):AddItem(sound, 5)
```