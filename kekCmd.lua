-- Gui to Lua
-- Version: 3.2

-- Instances:

local preload = tick()

local kekcmd = Instance.new("ScreenGui")
local cmdBar = Instance.new("Frame")
local outline = Instance.new("Frame")
local cmd = Instance.new("TextBox")
local preview = Instance.new("TextLabel")

--Properties:

kekcmd.Name = "kekcmd"
kekcmd.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
kekcmd.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
kekcmd.ResetOnSpawn = false

cmdBar.Name = "cmdBar"
cmdBar.Parent = kekcmd
cmdBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
cmdBar.BackgroundTransparency = 0.100
cmdBar.BorderSizePixel = 0
--cmdBar.Position = UDim2.new(0, 393.5, 0.858164489, 0)
cmdBar.Position = UDim2.new(0, 393.5, 1, 100)
cmdBar.Size = UDim2.new(0, 1133, 0, 33)

outline.Name = "outline"
outline.Parent = cmdBar
outline.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
outline.BorderSizePixel = 0
outline.Position = UDim2.new(0, 0, 1, 0)
outline.Size = UDim2.new(0, 1133, 0, 2)

cmd.Name = "cmd"
cmd.Parent = cmdBar
cmd.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cmd.BackgroundTransparency = 1.000
cmd.Position = UDim2.new(0.0105913505, 0, 0, 0)
cmd.Size = UDim2.new(0, 961, 0, 33)
cmd.ZIndex = 2
cmd.Font = Enum.Font.Roboto
cmd.MultiLine = false
cmd.PlaceholderColor3 = Color3.fromRGB(202, 202, 202)
cmd.PlaceholderText = "Type any command..."
cmd.Text = ""
cmd.TextColor3 = Color3.fromRGB(255, 255, 255)
cmd.TextSize = 18.000
cmd.TextWrapped = true
cmd.TextXAlignment = Enum.TextXAlignment.Left

preview.Name = "preview"
preview.Parent = cmdBar
preview.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
preview.BackgroundTransparency = 1.000
preview.Position = UDim2.new(0.0109999999, 0, 0, 0)
preview.Size = UDim2.new(0, 961, 0, 33)
preview.Font = Enum.Font.Roboto
preview.Text = ""
preview.TextColor3 = Color3.fromRGB(202, 202, 202)
preview.TextSize = 18.000
preview.TextXAlignment = Enum.TextXAlignment.Left

--

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local commands = {
    {"modguns", "Makes every weapon you equip twice overpowered."},
    {"unmodguns", "Disables modded weapons."},
    {"nofog", "Removes fog effects."},
    {"fog", "Enables fog effects."},
    {"noclip", "Noclips your player."},
    {"clip", "Clips your player."},
    {"pronespeed [num]", "Sets your prone speed to set value."},
    -- {"fly", "Enables flight."},
    -- {"unfly", "Disables flight."},
    {"xray", "Makes all parts transparent."},
    {"unxray", "Makes all parts opaque."},
    {"settime [num]", "Locks the time at num."},
    {"unsettime", "Returns to default time."},
}

local modWeapons = false
local Atmosphere = Lighting.Atmosphere
local noclipping = false
local InteractMain = getsenv(LocalPlayer.PlayerGui.InteractMain)
local proneSpeed = 2
local customTime = -1

function modWeapon(Gun)
    task.wait()
    if Gun:FindFirstChild("GunScript") and Gun:IsA("Tool") and modWeapons then
        local GunScript = getsenv(Gun.GunScript)
        local Settings = require(Gun.Settings)

        GunScript.auto = true
        Settings.auto = true

        --GunScript.maxammo = math.huge
        --Settings.maxammo = math.huge

        GunScript.scatter = 99999999999
        Settings.scatter = 99999999999

        GunScript.originalscatter = 99999999999

        GunScript.BulletSpeed = 9999999999
        Settings.BulletSpeed = 9999999999

        GunScript.LegMultiplier = 10
        Settings.LegMultiplier = 10

        GunScript.HeadMultiplier = 10
        Settings.HeadMultiplier = 10

        GunScript.TorsoMultiplier = 10
        Settings.TorsoMultiplier = 10

        GunScript.GunRecoil = 0
        Settings.GunRecoil = 0

        GunScript.AimFov = 50
        Settings.AimFov = 50

        GunScript.originalrecoil = 0

        GunScript.Damage = 100000
        Settings.Damage = 100000

        GunScript.ReloadSpeed = 0.01
        Settings.ReloadSpeed = 0.01

        Gun.Weight.Value = 0
    end
end

for _, Gun in pairs(LocalPlayer.Backpack:GetChildren()) do
    modWeapon(Gun)
end

LocalPlayer.Backpack.ChildAdded:Connect(function(Gun)
    modWeapon(Gun)
end)

LocalPlayer.CharacterAdded:Connect(function()
    LocalPlayer.Backpack.ChildAdded:Connect(function(Gun)
        modWeapon(Gun)
    end)

    for _, Gun in pairs(LocalPlayer.Backpack:GetChildren()) do
        modWeapon(Gun)
    end

    local IMAIN_WFC = LocalPlayer.PlayerGui:WaitForChild("InteractMain")
    InteractMain = getsenv(IMAIN_WFC)
    --[[local function attemptGetsenv()
        if not pcall(function()
            InteractMain = getsenv(IMAIN_WFC)
        end) then
            task.wait()
            attemptGetsenv()
        end
    end]]
    InteractMain.proneSpeed = proneSpeed
end)



RunService.RenderStepped:Connect(function()
    if noclipping and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
    if customTime ~= -1 then
        Lighting.ClockTime = customTime
    end
end)
--

UIS.InputBegan:Connect(function(input)
    local key = input.KeyCode

    if (key == Enum.KeyCode.Semicolon) and (not UIS:GetFocusedTextBox()) then
        cmd:CaptureFocus()
        cmdBar:TweenPosition(UDim2.new(0, 393.5, 0.858164489, 0), "Out", "Quad", 0.1)
        wait()
        cmd.Text = ""
    end
end)

cmd.FocusLost:Connect(function()
    cmdBar:TweenPosition(UDim2.new(0, 393.5, 1, 100), "In", "Quad", 0.1)
    if cmd.Text ~= "" then
        preview.Text = ""
        local command = cmd.Text:split(" ")[1]
        local args = cmd.Text:split(" ")

        if command == "modguns" then
            modWeapons = true
        elseif command == "unmodguns" then
            modWeapons = false
        elseif command == "nofog" then
            Atmosphere.Parent = nil
            Lighting.FogEnd = 99999999
        elseif command == "fog" then
            Atmosphere.Parent = Lighting
            Lighting.FogEnd = 1000
        elseif command == "noclip" then
            noclipping = true
        elseif command == "clip" then
            noclipping = false
            task.wait()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = true
                    end
                end
            end
        elseif command == "pronespeed" and tonumber(args[2]) ~= nil then
            InteractMain.proneSpeed = tonumber(args[2])
            proneSpeed = tonumber(args[2])
        elseif command == "settime" and tonumber(args[2]) ~= nil then
            customTime = tonumber(args[2])
        end
    end
end)


cmd:GetPropertyChangedSignal("Text"):Connect(function()
    task.wait()
    if cmd.Text ~= "" then
        local comfound = false
        for i, com in pairs(commands) do
            if cmd.Text == com[1]:sub(1, cmd.Text:len()) then
                preview.Text = com[1].." - "..com[2]
                comfound = true
            end
        end
        if not comfound then
            preview.Text = ""
        end
    else
        preview.Text = ""
    end
end)
