
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

-- Try load Rayfield
local successRay, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not successRay or not Rayfield then
    warn("Không tải được Rayfield. Hãy đảm bảo executor có internet và Rayfield URL hợp lệ.")
    return
end

-- Create Window (KeySystem = true, chỉ 1 key Ditcubdvn111)
local Window = Rayfield:CreateWindow({
    Name = "Menu Bdvn2 Ba' SV",
    LoadingTitle = "Menu Bdvn2 Ba' SV",
    LoadingSubtitle = "By Bdvn",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Bdvn2Menu",
        FileName = "MenuConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "Menu Bdvn2 Ba' SV",
        Subtitle = "Nhập key để tiếp tục",
        Note = "key in https://discord.gg/VxXP5Z9sZC",
        FileName = "Bdvn2Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Ditcubdvn111"}
    }
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local InfoTab = Window:CreateTab("Info", 4483362458)

-- ======================
-- Auto Kill (bỏ qua bạn bè)
-- ======================
local autoKillEnabled = false
local autoKillRange = 1000 -- default range (không dùng distance filtering in this implementation; keep for future)

-- Toggle AutoKill
MainTab:CreateToggle({
    Name = "Auto Kill (bỏ qua bạn bè)",
    CurrentValue = false,
    Flag = "AutoKillToggle",
    Callback = function(value)
        autoKillEnabled = value
        if value then
            Rayfield:Notify({ Title = "Auto Kill", Content = "Đã bật Auto Kill", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Auto Kill", Content = "Đã tắt Auto Kill", Duration = 2 })
        end
    end
})

-- Optional slider to set a range value (for reference)
MainTab:CreateSlider({
    Name = "Range (tham khảo)",
    Min = 50,
    Max = 5000,
    Increment = 50,
    Suffix = "m",
    CurrentValue = autoKillRange,
    Flag = "AutoKillRange",
    Callback = function(value)
        autoKillRange = value
    end
})

-- Auto-kill loop: kích hoạt tool & firetouchinterest qua tất cả parts của target
RunService.RenderStepped:Connect(function()
    if not autoKillEnabled then return end
    -- iterate players
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            -- skip if friend
            local ok, isFriend = pcall(function()
                return LocalPlayer:IsFriendsWith(other.UserId)
            end)
            if not ok then isFriend = false end
            if not isFriend then
                -- attempt to use player's tool handle to touch other player's parts
                local myChar = LocalPlayer.Character
                if myChar then
                    local tool = myChar:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        pcall(function() tool:Activate() end)
                        for _, part in ipairs(other.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                pcall(function()
                                    firetouchinterest(tool.Handle, part, 0)
                                    firetouchinterest(tool.Handle, part, 1)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ======================
-- Helper: safe load remote script
-- ======================
local function safeLoadRemote(url)
    local ok, err = pcall(function()
        local resp = game:HttpGet(url)
        if type(resp) == "string" and #resp > 0 then
            local loadOk, loadErr = pcall(function()
                loadstring(resp)()
            end)
            if not loadOk then
                error(loadErr or "Lỗi loadstring")
            end
        else
            error("Không lấy được nội dung từ: "..tostring(url))
        end
    end)
    return ok, err
end

-- ======================
-- Buttons chạy script
-- ======================

-- 1) Troller (ITatzuki)
MainTab:CreateButton({
    Name = "Troller (ITatzuki)",
    Callback = function()
        local url = "https://raw.githubusercontent.com/ITatzukiVN/FisrtScriptByITatzuki.lua/refs/heads/main/skibidi1"
        local ok, err = safeLoadRemote(url)
        if ok then
            Rayfield:Notify({ Title = "Troller", Content = "Đã chạy Troller ✅", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Troller - Lỗi", Content = tostring(err), Duration = 4 })
        end
    end
})

-- 2) Acsmusic (mở nhạc)
MainTab:CreateButton({
    Name = "Acsmusic (Music)",
    Callback = function()
        local url = "https://raw.githubusercontent.com/Roblox-HttpSpy/my-Garbage/refs/heads/main/FeMusicExploit.lua"
        local ok, err = safeLoadRemote(url)
        if ok then
            Rayfield:Notify({ Title = "Acsmusic", Content = "Đã mở Acsmusic ✅", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Acsmusic - Lỗi", Content = tostring(err), Duration = 4 })
        end
    end
})

-- 3) Infinite Yield
MainTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        local url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
        local ok, err = safeLoadRemote(url)
        if ok then
            Rayfield:Notify({ Title = "Infinite Yield", Content = "Đã chạy Infinite Yield ✅", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Infinite Yield - Lỗi", Content = tostring(err), Duration = 4 })
        end
    end
})

-- ======================
-- Info Tab: Discord copy
-- ======================
InfoTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        local discordLink = "https://discord.gg/VxXP5Z9sZC"
        pcall(function() setclipboard(discordLink) end)
        Rayfield:Notify({ Title = "Discord", Content = "Đã copy link Discord ✅", Duration = 3 })
    end
})

-- ======================
-- Finished
-- ======================
Rayfield:Notify({ Title = "Menu Bdvn2", Content = "Khởi tạo xong — Nhập key: Ditcubdvn111 để sử dụng", Duration = 4 })
