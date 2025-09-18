-- TT: khanhdevxyz | Rayfield AimLock Demo
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
local AimLockEnabled = false
local FOV = 100 -- khoảng ảnh hưởng
local TargetPart = "HumanoidRootPart" -- bone để aim
local Smoothness = 0.3 -- độ mượt khi quay camera

-- Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name="TT: khanhdevxyz"})
local AimTab = Window:CreateTab("AimLock")

-- Toggle AimLock
AimTab:CreateToggle({
    Name="AimLock",
    CurrentValue=false,
    Callback=function(Value)
        AimLockEnabled = Value
        Rayfield:Notify({
            Title="AimLock",
            Content=Value and "AimLock bật!" or "AimLock tắt!",
            Duration=3
        })
    end
})

-- Slider: FOV
AimTab:CreateSlider({
    Name="FOV",
    Range={50,500},
    Increment=5,
    CurrentValue=100,
    Callback=function(Value)
        FOV = Value
    end
})

-- Slider: Smoothness
AimTab:CreateSlider({
    Name="Smoothness",
    Range={0.05,1},
    Increment=0.05,
    CurrentValue=0.3,
    Callback=function(Value)
        Smoothness = Value
    end
})

-- AimLock Logic
RunService.RenderStepped:Connect(function()
    if AimLockEnabled then
        local closestPlayer = nil
        local shortestDistance = FOV

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(TargetPart) then
                local pos, onScreen = Camera:WorldToViewportPoint(plr.Character[TargetPart].Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(pos.X,pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = plr
                        shortestDistance = distance
                    end
                end
            end
        end

        if closestPlayer then
            local targetPos = closestPlayer.Character[TargetPart].Position
            local direction = (targetPos - Camera.CFrame.Position)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction), Smoothness)
        end
    end
end)
