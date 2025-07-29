local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local suspiciousRemoteNames = {
    "HitboxEvent", "DestroyEvent", "SetDialogInUse",
    "ContactListInvokeIrisinvite", "ContactListInvokeIrisinviteTeleport",
    "UpdateCurrentCall", "RequestDeviceCameraOrientation",
    "RequestDeviceCameraCFrame", "ReciveLikelySpeakingUsers",
    "ReferedPlayerJoin", "UpdateLocalPlayerBlockList",
    "SendPlayerProfileSettings", "SetDialougeInUse", "BridgeNet2",
    "IntegrityCheckProcessorkey2_DynamicTranslationSender_LocalizationService",
    "5e2f7c07-ce64-4ff0-976f-6f8fc38f9ee"
}

local suspiciousRemotes = {}

for _, name in ipairs(suspiciousRemoteNames) do
    local remote = ReplicatedStorage:FindFirstChild(name)
    if remote and remote:IsA("RemoteEvent") then
        table.insert(suspiciousRemotes, remote)
    elseif remote and remote:IsA("Folder") then
        for _, child in pairs(remote:GetChildren()) do
            if child:IsA("RemoteEvent") then
                table.insert(suspiciousRemotes, child)
            end
        end
    else

        local parts = string.split(name, ".")
        if #parts > 1 then
            local parent = ReplicatedStorage:FindFirstChild(parts[1])
            if parent then
                local nestedRemote = parent:FindFirstChild(parts[2])
                if nestedRemote and nestedRemote:IsA("RemoteEvent") then
                    table.insert(suspiciousRemotes, nestedRemote)
                end
            end
        end
    end
end

if game.PlaceId == 17072376063 then
    local OrionLib = loadstring(game:HttpGet(
                                    ('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
    local Window = OrionLib:MakeWindow({
        Name = "HelDark Hub",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "OrionTest"
    })

    _G.StrAutoFarm = false
    _G.AutoHealthFarm = false
    local killAuraEnabled = false
    local killAuraRange = 15

    local function AutoHealthFarm()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Modules = ReplicatedStorage:WaitForChild("Modules")
        local BridgeNet = require(Modules:WaitForChild("BridgeNet2"))

        local pullUpRemote = BridgeNet.ReferenceBridge(
                                 "imadumbexploiter3527d36bd7d656f96a836f1df5085590")

        local DUPLIKATIONEN = 150

        while true do
            for i = 2, DUPLIKATIONEN * 10 * 2.5 do
                pullUpRemote:Fire()
            end
            task.wait(2)
        end
    end

    local function StrAutoFarm()

        -- 𝐇𝐞𝐥𝐃𝐚𝐫𝐤𝐬 - FUERZA 😛🧬

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Modules = ReplicatedStorage:WaitForChild("Modules")
        local BridgeNet = require(Modules:WaitForChild("BridgeNet2"))

        local remote = BridgeNet.ReferenceBridge(
                           "imadumbexploiter9d7f88729c2c6ceff3bb1ce223049848")

        local ANZAHL_DUPLIKATIONEN = 150

        while true do
            for i = 2, ANZAHL_DUPLIKATIONEN * 10 * 2.5 do
                remote:Fire()
            end
            task.wait(2)
        end

    end

    local FarmTab = Window:MakeTab({
        Name = "Autofarm",
        Icon = "rbxassetid://74077778",
        PremiumOnly = false
    })

    FarmTab:AddToggle({
        Name = "Auto Strength",
        Default = false,
        Callback = function(Value)
            _G.StrAutoFarm = Value
            if Value then StrAutoFarm() end
        end
    })

    FarmTab:AddToggle({
        Name = "Auto Health",
        Default = false,
        Callback = function(Value)
            _G.AutoHealthFarm = Value
            if Value then AutoHealthFarm() end
        end
    })

    local FarmTab1 = Window:MakeTab({
        Name = "Kill Aura",
        Icon = "rbxassetid://74077778",
        PremiumOnly = false
    })

    local allowed = {["HERLAN37237"] = true, ["Elcapo3000677"] = true}

    local lp = game:GetService("Players").LocalPlayer
    if not allowed[lp.Name] then return end

    local RS = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local remote = ReplicatedStorage:FindFirstChild("HitboxEvent")
    local char = lp.Character or lp.CharacterAdded:Wait()

    local lastHit = {}
    local COOLDOWN = 0.75
    local RANGE = 500

    local function legitHit(target)
        local args = {
            ["Target"] = target,
            ["HitTime"] = tick(),
            ["Position"] = target:FindFirstChild("HumanoidRootPart").Position,
            ["From"] = char:FindFirstChild("HumanoidRootPart").Position
        }
        pcall(function() remote:FireServer(args) end)
    end

    RS.Stepped:Connect(function()
        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= lp and plr.Character and
                plr.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (plr.Character.HumanoidRootPart.Position -
                                     char.HumanoidRootPart.Position).Magnitude
                if distance <= RANGE then
                    if (tick() - (lastHit[plr] or 0)) >= COOLDOWN then
                        lastHit[plr] = tick()
                        legitHit(plr.Character)
                    end
                end
            end
        end
    end)

    FarmTab1:AddToggle({
        Name = "Kill Aura",
        Default = false,
        Callback = function(Value) killAuraEnabled = Value end
    })

    FarmTab1:AddSlider({
        Name = "Distancia del Kill Aura",
        Min = 5,
        Max = 50,
        Default = 15,
        Increment = 1,
        Callback = function(Value) killAuraRange = Value end
    })

    local FarmTab2 = Window:MakeTab({
        Name = "Configuration",
        Icon = "rbxassetid://74077778",
        PremiumOnly = false
    })

    local treesFolder = game.Workspace:FindFirstChild("Trees")
    local savedTrees = {}
    local AntiLagEnabled = false

    FarmTab2:AddToggle({
        Name = "AntiLag (Ocultar/Mostrar Árboles)",
        Default = false,
        Callback = function(Value)
            AntiLagEnabled = Value
            if treesFolder then
                if Value then
                    for _, tree in pairs(treesFolder:GetChildren()) do
                        table.insert(savedTrees, tree)
                        tree.Parent = nil
                    end
                else
                    for _, tree in pairs(savedTrees) do
                        tree.Parent = treesFolder
                    end
                    savedTrees = {}
                end
            end
        end
    })

    local expandHitboxes = false

    FarmTab2:AddToggle({
        Name = "Expandir Hitbox de otros jugadores",
        Default = false,
        Callback = function(Value)
            expandHitboxes = Value
            if Value then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Size = part.Size + Vector3.new(10, 10, 10)
                            end
                        end
                    end
                end
            else
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Size = Vector3.new(1, 1, 0.5)
                            end
                        end
                    end
                end
            end
        end
    })

    FarmTab2:AddToggle({
        Name = "Mostrar Hitbox Visual (Aura)",
        Default = false,
        Callback = function(Value) expandHitboxes = Value end
    })

    local CreditsTab = Window:MakeTab({
        Name = "Credits",
        Icon = "rbxassetid://74077778",
        PremiumOnly = false
    })

    CreditsTab:AddParagraph("Hecho por:",
                            "darkpro77731 - Elcapo3000677 / HERLAN37237")

    OrionLib:Init()
end
