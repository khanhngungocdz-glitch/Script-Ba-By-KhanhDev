-- Auto Win Teleport Script
-- TT: khanhdevxyz

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local winPartName = "FinishPart"

-- Hàm tìm FinishPart
local function getWinPart()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == winPartName then
            return v
        end
    end
end

-- Hàm teleport tới FinishPart
local function tpToWin()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local winPart = getWinPart()
    if hrp and winPart then
        hrp.CFrame = winPart.CFrame + Vector3.new(0,3,0)
    end
end

-- Luôn auto teleport khi bật script
task.spawn(function()
    while true do
        tpToWin()
        task.wait(0.5) -- 0.5 giây teleport 1 lần
    end
end)

-- Nếu nhân vật chết thì tiếp tục chạy lại
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    while LocalPlayer.Character do
        tpToWin()
        task.wait(0.5)
    end
end)
