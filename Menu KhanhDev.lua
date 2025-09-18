-- TT:khanhdevxyz | Key: DVXZkey728391

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window + Key System
local Window = Rayfield:CreateWindow({
    Name = "TT:khanhdevxyz",
    LoadingTitle = "TT:khanhdevxyz",
    LoadingSubtitle = "Vip Script Menu",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "MenuConfig"
    },
    KeySystem = true, -- bật Key
    KeySettings = {
        Title = "TT:khanhdevxyz | Key System",
        Subtitle = "Enter your key to unlock",
        Note = "Get key tại nút Get Key",
        SaveKey = true,
        Key = {"DVXZkey728391"} -- key hợp lệ
    },
    Theme = {
        Background = Color3.fromRGB(255, 255, 255),
        Topbar = Color3.fromRGB(245, 245, 245),
        Border = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0, 0, 0),
        Elements = Color3.fromRGB(230, 230, 230),
        Notifications = Color3.fromRGB(255, 255, 255),
        HoverColor = Color3.fromRGB(200, 230, 255) -- màu khi hover nút
    }
})

-- Tabs
local MainTab = Window:CreateTab("⚡ Main", 4483362458)
local KeyTab = Window:CreateTab("🔑 Key", 4483362458)

-- ===== Key Tab: Get Key Button =====
KeyTab:CreateButton({
   Name = "📋 Copy Get Key Link",
   Callback = function()
      setclipboard("https://link4m.com/0FXvTz")
      Rayfield:Notify({
         Title = "Copied!",
         Content = "Link key đã được copy vào clipboard.",
         Duration = 5
      })
   end
})

-- Variables
local AutoAttack = false
local AutoSpin = false
local SpeedBoost = false
local ShowHP = false
local SpinSpeed = 2500
local AttackDelay = 0.08
local NormalSpeed = 16
local BoostSpeed = 32

-- Toggle: Auto Attack
MainTab:CreateToggle({
    Name = "⚔️ Auto Attack",
    CurrentValue = false,
    Flag = "AutoAttack",
    Callback = function(Value)
        AutoAttack = Value
    end,
})

-- Toggle: Spin
MainTab:CreateToggle({
    Name = "🔄 Spin",
    CurrentValue = false,
    Flag = "Spin",
    Callback = function(Value)
        AutoSpin = Value
    end,
})

-- Toggle: Speed Boost
MainTab:CreateToggle({
    Name = "🏃 Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(Value)
        SpeedBoost = Value
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = SpeedBoost and BoostSpeed or NormalSpeed
        end
    end,
})

-- Toggle: Show HP Player
MainTab:CreateToggle({
    Name = "❤️ Show HP Player",
    CurrentValue = false,
    Flag = "ShowHP",
    Callback = function(Value)
        ShowHP = Value
    end,
})

-- Button: Get Bandage
MainTab:CreateButton({
    Name = "🩹 Get Bandage",
    Callback = function()
        local char = LocalPlayer.Character
        if not char or char:FindFirstChildOfClass("Tool") then
            Rayfield:Notify({
                Title = "⚠️ Failed",
                Content = "Drop weapon before getting bandage!",
                Duration = 4
            })
            return
        end

        local success = pcall(function()
            local knitIndex = ReplicatedStorage:FindFirstChild("KnitPackages") 
                and ReplicatedStorage.KnitPackages._Index:FindFirstChild("sleitnick_knit@1.7.0")
            if knitIndex then
                local invService = knitIndex.knit.Services.InventoryService.RE.updateInventory
                if invService then
                    invService:FireServer("refresh")
                    task.wait(0.3)
                    invService:FireServer("eue","băng gạc")
                end
            end
        end)

        if success then
            Rayfield:Notify({
                Title = "✅ Success",
                Content = "Bandage received!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "❌ Error",
                Content = "Failed to get bandage.",
                Duration = 3
            })
        end
    end,
})

-- Logic Auto Attack
task.spawn(function()
    while task.wait(AttackDelay) do
        if AutoAttack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            VirtualUser:ClickButton1(Vector2.new())
        end
    end
end)

-- Logic Auto Spin
RunService.RenderStepped:Connect(function(deltaTime)
    if AutoSpin and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(SpinSpeed * deltaTime), 0)
    end
end)

-- Logic Speed giữ khi chết
LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = SpeedBoost and BoostSpeed or NormalSpeed
end)

-- Logic Show HP
local PlayerHPGuis = {}
RunService.RenderStepped:Connect(function()
    if ShowHP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                if not PlayerHPGuis[player] then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 100, 0, 30)
                    billboard.Adornee = head
                    billboard.AlwaysOnTop = true
                    billboard.Parent = head

                    local hpLabel = Instance.new("TextLabel")
                    hpLabel.Size = UDim2.new(1,0,1,0)
                    hpLabel.BackgroundTransparency = 1
                    hpLabel.TextColor3 = Color3.fromRGB(255,0,0)
                    hpLabel.Font = Enum.Font.GothamBold
                    hpLabel.TextSize = 14
                    hpLabel.TextStrokeTransparency = 0
                    hpLabel.Parent = billboard

                    PlayerHPGuis[player] = hpLabel
                end
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    PlayerHPGuis[player].Text = string.format("%d / %d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                end
            end
        end
    else
        for player, gui in pairs(PlayerHPGuis) do
            if gui and gui.Parent then
                gui.Parent:Destroy()
            end
        end
        PlayerHPGuis = {}
    end
end)
