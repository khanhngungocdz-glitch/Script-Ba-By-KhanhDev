-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local lp = Players.LocalPlayer
local hrp, hum

-- ===== Character Handler =====
local function getChar()
    local char = lp.Character or lp.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
    return char
end
getChar()
lp.CharacterAdded:Connect(function()
    task.wait(1)
    getChar()
end)

-- ===== Find Nearest NPC2 =====
local function getNearestNPC2()
    local nearest, dist, hrp2 = nil, math.huge, nil
    for _, m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m.Name == "NPC2" then
            local h = m:FindFirstChildOfClass("Humanoid")
            local p = m:FindFirstChild("HumanoidRootPart")
            if h and p and h.Health > 0 then
                local d = (p.Position - hrp.Position).Magnitude
                if d < dist then
                    nearest, dist, hrp2 = m, d, p
                end
            end
        end
    end
    return nearest, hrp2, dist
end

-- ===== Auto Attack =====
local lastAttack = 0
local attackInterval = 0.3
local function performAttack()
    if os.clock() - lastAttack < attackInterval then return end
    lastAttack = os.clock()
    local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
    if not tool and lp.Backpack then
        tool = lp.Backpack:FindFirstChildOfClass("Tool")
        if tool then tool.Parent = lp.Character end
    end
    if tool then pcall(function() tool:Activate() end) end
end

-- // Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🇻🇳 TT: khanhdevxyz",
   LoadingTitle = "Welcome",
   LoadingSubtitle = "Menu by KhanhDev",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "TTMenu",
      FileName = "FarmConfig"
   },
   KeySystem = true,
   KeySettings = {
      Title = "Menu Key",
      Subtitle = "Enter your key",
      Note = "Get Key:https://link4m.com/0FXvTz",
      FileName = "TTKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"DVXZkey728391"}
   }
})

-- // Tab chính
local Tab = Window:CreateTab("⚡ Main", 4483362458)

-- Toggle Farm
local farming = false
Tab:CreateToggle({
   Name = "Farm Boss",
   CurrentValue = false,
   Flag = "Farm",
   Callback = function(Value)
      farming = Value
   end
})

-- Orbit Distance
local orbitDist = 10
Tab:CreateSlider({
   Name = "Orbit Distance",
   Range = {5, 50},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = orbitDist,
   Flag = "OrbitDist",
   Callback = function(Value)
      orbitDist = Value
   end
})

-- Orbit Speed
local orbitSpeed = 15
Tab:CreateSlider({
   Name = "Orbit Speed",
   Range = {5, 50},
   Increment = 1,
   Suffix = " speed",
   CurrentValue = orbitSpeed,
   Flag = "OrbitSpd",
   Callback = function(Value)
      orbitSpeed = Value
   end
})

-- Server Hop
Tab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local gameId = game.PlaceId
      local cursor, smallest, serverId = "", math.huge, nil
      repeat
          local url = "https://games.roblox.com/v1/games/"..gameId.."/servers/Public?sortOrder=Asc&limit=100"..(cursor ~= "" and "&cursor="..cursor or "")
          local data = HttpService:JSONDecode(game:HttpGet(url))
          for _, s in ipairs(data.data) do
              if s.playing < smallest and s.id ~= game.JobId then
                  smallest = s.playing
                  serverId = s.id
              end
          end
          cursor = data.nextPageCursor or ""
      until cursor == "" or serverId
      if serverId then
          TeleportService:TeleportToPlaceInstance(gameId, serverId, lp)
      else
          warn("No other server found!")
      end
   end
})

-- NPC HUD
local npcLabel = Tab:CreateLabel("NPC2: ??? / ???")

-- ===== Farm Logic =====
local orbitAngle = 0
RunService.Heartbeat:Connect(function(dt)
    if not farming or not hrp or not hum or hum.Health <= 0 then return end
    local npc, npcHRP = getNearestNPC2()
    if not npc or not npcHRP then return end
    orbitAngle = orbitAngle + dt * orbitSpeed
    local offset = Vector3.new(math.cos(orbitAngle), 0, math.sin(orbitAngle)) * orbitDist
    local targetPos = npcHRP.Position + offset
    hrp.CFrame = CFrame.new(targetPos, npcHRP.Position)
    performAttack()
end)

-- ===== Update HUD =====
RunService.Heartbeat:Connect(function()
    local npc = getNearestNPC2()
    if npc and npc:FindFirstChildOfClass("Humanoid") then
        local h = npc:FindFirstChildOfClass("Humanoid")
        npcLabel:Set("NPC2 HP: "..math.floor(h.Health).." / "..h.MaxHealth)
    else
        npcLabel:Set("NPC2: Not found")
    end
end)
