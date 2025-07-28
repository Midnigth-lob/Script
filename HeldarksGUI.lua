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

    -- Tabla para guardar las auras de cada jugador
    local auraParts = {}

    -- Función para crear aura para un jugador
    local function createAuraForPlayer(player)
        if auraParts[player] then return auraParts[player] end
        local part = Instance.new("Part")
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(killAuraRange * 2, killAuraRange * 2, killAuraRange * 2)
        part.Transparency = 0.5
        part.Color = Color3.fromRGB(255, 0, 0)
        part.Material = Enum.Material.ForceField
        part.Anchored = true
        part.CanCollide = false
        part.Parent = workspace
        auraParts[player] = part
        return part
    end

    local hitboxAuraEnabled = false

    task.spawn(function()
        while true do
            if killAuraEnabled then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude

                        -- Kill Aura
                        if dist <= killAuraRange then
                            -- Intento matar enviando el HumanoidRootPart
                            HitboxRemote:FireServer(player.Character.HumanoidRootPart)
                        end

                        -- Actualizar aura visual si está habilitado
                        if hitboxAuraEnabled then
                            local aura = createAuraForPlayer(player)
                            aura.Size = Vector3.new(killAuraRange * 2, killAuraRange * 2, killAuraRange * 2)
                            aura.Position = player.Character.HumanoidRootPart.Position
                            aura.Transparency = 0.5
                            aura.Parent = workspace
                        elseif auraParts[player] then
                            auraParts[player]:Destroy()
                            auraParts[player] = nil
                        end
                    elseif auraParts[player] then
                        auraParts[player]:Destroy()
                        auraParts[player] = nil
                    end
                end
            else
                -- Cuando killAura está apagado, destruir todas las auras
                for p, aura in pairs(auraParts) do
                    aura:Destroy()
                    auraParts[p] = nil
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
                                part.Size = Vector3.new(2, 2, 1) -- Ajustar según el tamaño original estándar
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
        Callback = function(Value)
            hitboxAuraEnabled = Value
        end
    })

    OrionLib:Init()
end

