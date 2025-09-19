-- TT:khanhdevxyz | Nhin Cc
-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Boss Tracking
local boss, bossHum, bossHRP
local bossBar, bossName, bossHP
local lastAttack = 0
local attackDelay = 0.7
local retargetInterval = 0.5
local lastRetarget = 0

-- Configs
local orbitEnabled = false
local attackEnabled = false
local orbitRadius = 10
local orbitSpeed = 3
local smoothFollow = 15

-- Rayfield Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Key System
Rayfield:CreateKeySystem({
    KeySettings = {
        Title = "Farm bot Dev🥴",
        Subtitle = "Enter your key",
        Note = "Key In https://discord.gg/VxXP5Z9sZC",
        SaveKey = false,
        GrabKeyFromSite = false,
        Actions = {
            [1] = {
                Text = "Get Key",
                OnPress = function() setclipboard("DVXZkey728391") end,
            }
        },
        Keys = {"DVXZkey728391"}
    }
})

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Farm bot Dev🥴",
    LoadingTitle = "Farm bot Dev🥴",
    LoadingSubtitle = "by khanhdevxyz",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Tabs
local FarmTab = Window:CreateTab("Farm", "swords")
local StatusTab = Window:CreateTab("Status", "activity")

-- Toggles
FarmTab:CreateToggle({
    Name = "Auto Orbit Boss 🔥",
    CurrentValue = false,
    Flag = "Orbit",
    Callback = function(val) orbitEnabled = val end
})

FarmTab:CreateToggle({
    Name = "Auto Attack 👊",
    CurrentValue = false,
    Flag = "Attack",
    Callback = function(val) attackEnabled = val end
})

-- Sliders
FarmTab:CreateSlider({
    Name = "Orbit Radius",
    Range = {5, 25},
    Increment = 1,
    CurrentValue = orbitRadius,
    Flag = "Radius",
    Callback = function(val) orbitRadius = val end
})

FarmTab:CreateSlider({
    Name = "Orbit Speed",
    Range = {1, 10},
    Increment = 0.5,
    CurrentValue = orbitSpeed,
    Flag = "Speed",
    Callback = function(val) orbitSpeed = val end
})

FarmTab:CreateSlider({
    Name = "Smooth Follow",
    Range = {5, 30},
    Increment = 1,
    CurrentValue = smoothFollow,
    Flag = "Smooth",
    Callback = function(val) smoothFollow = val end
})

-- Status Labels
local BossLabel = StatusTab:CreateLabel("Boss: None")
local HPLabel = StatusTab:CreateLabel("HP: 0/0")

-- Progress bar bằng cách fake Label update
local function updateBossUI()
    if boss and bossHum and bossHum.Health > 0 then
        BossLabel:Set("Boss: " .. boss.Name)
        HPLabel:Set("HP: " .. math.floor(bossHum.Health) .. "/" .. math.floor(bossHum.MaxHealth))
    else
        BossLabel:Set("Boss: None")
        HPLabel:Set("HP: 0/0")
    end
end

-- Find Nearest Boss
local function findBoss()
    local closest, dist = nil, math.huge
    for _, m in ipairs(workspace:GetChildren()) do
        if m:IsA("Model") and m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") then
            local h = m.Humanoid
            if h.Health > 0 and h.MaxHealth >= 5000 then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - m.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    closest, dist = m, d
                end
            end
        end
    end
    return closest
end

-- Billboard HP
local function createBillboard(target)
    if target:FindFirstChild("BossBillboard") then return end
    local bb = Instance.new("BillboardGui", target)
    bb.Name = "BossBillboard"
    bb.Size = UDim2.new(4,0,1,0)
    bb.AlwaysOnTop = true
    bb.Adornee = target:FindFirstChild("HumanoidRootPart")

    local bar = Instance.new("Frame", bb)
    bar.Size = UDim2.new(1,0,0.2,0)
    bar.Position = UDim2.new(0,0,0,0)
    bar.BackgroundColor3 = Color3.fromRGB(255,0,0)

    local uic = Instance.new("UICorner", bar)
    uic.CornerRadius = UDim.new(0,6)

    bossBar = bar
end

-- Main Loop
RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    -- Boss Tracking
    lastRetarget = lastRetarget + dt
    if lastRetarget >= retargetInterval then
        lastRetarget = 0
        boss = findBoss()
        if boss then
            bossHum = boss:FindFirstChild("Humanoid")
            bossHRP = boss:FindFirstChild("HumanoidRootPart")
            createBillboard(boss)
        else
            bossHum, bossHRP = nil, nil
        end
    end

    -- Orbit
    if orbitEnabled and boss and bossHRP then
        local t = tick() * orbitSpeed
        local targetPos = bossHRP.Position + Vector3.new(math.cos(t)*orbitRadius, 0, math.sin(t)*orbitRadius)
        hrp.Velocity = (targetPos - hrp.Position) * smoothFollow
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, bossHRP.Position)
    end

    -- Auto Attack
    if attackEnabled and boss and bossHum and bossHum.Health > 0 then
        lastAttack = lastAttack + dt
        if lastAttack >= attackDelay then
            lastAttack = 0
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new())
            end)
        end
    end

    -- Boss HP UI update
    if boss and bossHum and bossHum.Health > 0 and bossBar then
        bossBar.Size = UDim2.new(bossHum.Health/bossHum.MaxHealth, 0, 0.2, 0)
    end
    updateBossUI()
end)
