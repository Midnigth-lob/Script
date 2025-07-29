local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Lista de remotes sospechosos
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

-- Buscar remotes y sus hijos si es folder
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
        -- Si el nombre tiene punto, buscar nested remote
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
        Name = "darkpro77731 - Elcapo3000677 Ro-Karate Script",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "OrionTest"
    })

    _G.StrAutoFarm = false
    _G.AutoHealthFarm = false
    local killAuraEnabled = false
    local killAuraRange = 15

    local Modules = ReplicatedStorage:WaitForChild("Modules")
    local BridgeNet = require(Modules:WaitForChild("BridgeNet2"))

    local function AutoHealthFarm()
        task.spawn(function()
            local pullUpRemote = BridgeNet.ReferenceBridge(
                                     "imadumbexploiter3527d36bd7d656f96a836f1df5085590")
            while _G.AutoHealthFarm do
                for i = 1, 150 * 10 * 2.5 do pullUpRemote:Fire() end
                task.wait(2)
            end
        end)
    end

    local function StrAutoFarm()
        task.spawn(function()
            local remote = BridgeNet.ReferenceBridge(
                               "imadumbexploiter9d7f88729c2c6ceff3bb1ce223049848")
            while _G.StrAutoFarm do
                for i = 1, 150 * 10 * 2.5 do remote:Fire() end
                task.wait(2)
            end
        end)
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

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Crear el "aura"
    local aura = Instance.new("Part")
    aura.Name = "KillAura"
    aura.Shape = Enum.PartType.Ball
    aura.Size = Vector3.new(10, 10, 10) -- Radio del aura
    aura.Transparency = 1 -- Invisible, poné 0.5 si querés ver el hitbox
    aura.Anchored = false
    aura.CanCollide = false
    aura.Massless = true
    aura.Parent = workspace

    -- Soldarlo al personaje
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = character:WaitForChild("HumanoidRootPart")
    weld.Part1 = aura
    weld.Parent = aura

    -- Detección de golpes
    aura.Touched:Connect(function(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        local targetPlayer = game.Players:GetPlayerFromCharacter(hit.Parent)

        if humanoid and targetPlayer ~= player then
            -- Daño directo (si no se usa Remote)
            humanoid:TakeDamage(25)
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

    OrionLib:Init()
end
