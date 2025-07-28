if game.PlaceId == 17072376063 then
    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
    local Window = OrionLib:MakeWindow({
        Name = "HelDark Ro-Karate Script",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "OrionTest"
    })

    _G.StrAutoFarm = false
    _G.AutoHealthFarm = false
    local killAuraEnabled = false
    local killAuraRange = 15

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Modules = ReplicatedStorage:WaitForChild("Modules")
    local BridgeNet = require(Modules:WaitForChild("BridgeNet2"))
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function AutoHealthFarm()
        task.spawn(function()
            local pullUpRemote = BridgeNet.ReferenceBridge("imadumbexploiter3527d36bd7d656f96a836f1df5085590")
            while _G.AutoHealthFarm do
                for i = 1, 150 * 10 * 2.5 do
                    pullUpRemote:Fire()
                end
                task.wait(2)
            end
        end)
    end

    local function StrAutoFarm()
        task.spawn(function()
            local remote = BridgeNet.ReferenceBridge("imadumbexploiter9d7f88729c2c6ceff3bb1ce223049848")
            while _G.StrAutoFarm do
                for i = 1, 150 * 10 * 2.5 do
                    remote:Fire()
                end
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

    local HitboxRemote = ReplicatedStorage:WaitForChild("HitboxClassRemote")

    task.spawn(function()
    while true do
        if killAuraEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= killAuraRange then
                            -- Aquí disparás el remote pasando el HumanoidRootPart para el hitbox
                            HitboxRemote:FireServer(player.Character.HumanoidRootPart)
                        end
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)


    FarmTab1:AddToggle({
        Name = "Kill Aura",
        Default = false,
        Callback = function(Value)
            killAuraEnabled = Value
        end
    })

    FarmTab1:AddSlider({
        Name = "Distancia del Kill Aura",
        Min = 5,
        Max = 50,
        Default = 15,
        Increment = 1,
        Callback = function(Value)
            killAuraRange = Value
        end
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

    -- Hitbox Visual System
    local hitboxAuraEnabled = false
    local auraPart

    FarmTab2:AddToggle({
        Name = "Mostrar Hitbox Visual (Aura)",
        Default = false,
        Callback = function(Value)
            hitboxAuraEnabled = Value
            if Value then
                if not auraPart then
                    auraPart = Instance.new("Part")
                    auraPart.Shape = Enum.PartType.Ball
                    auraPart.Size = Vector3.new(killAuraRange * 2, killAuraRange * 2, killAuraRange * 2)
                    auraPart.Transparency = 0.5
                    auraPart.Color = Color3.fromRGB(255, 0, 0)
                    auraPart.Material = Enum.Material.ForceField
                    auraPart.Anchored = true
                    auraPart.CanCollide = false
                    auraPart.Parent = workspace
                end
                task.spawn(function()
                    while hitboxAuraEnabled do
                        auraPart.Size = Vector3.new(killAuraRange * 2, killAuraRange * 2, killAuraRange * 2)
                        auraPart.Position = LocalPlayer.Character.HumanoidRootPart.Position
                        task.wait()
                    end
                end)
            else
                if auraPart then
                    auraPart:Destroy()
                    auraPart = nil
                end
            end
        end
    })

    -- Hitbox Expand System
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
                                part.Size = part.Size + Vector3.new(3, 3, 3)
                            end
                        end
                    end
                end
            else
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Size = Vector3.new(2, 2, 1) -- Tamaño estándar, ajustar según el juego
                            end
                        end
                    end
                end
            end
        end
    })

    OrionLib:Init()
end
