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

    local function AutoHealthFarm()
        task.spawn(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Modules = ReplicatedStorage:WaitForChild("Modules")
            local BridgeNet = require(Modules:WaitForChild("BridgeNet2"))
            local pullUpRemote = BridgeNet.ReferenceBridge("imadumbexploiter3527d36bd7d656f96a836f1df5085590")
            local DUPLIKATIONEN = 150

            while _G.AutoHealthFarm do
                for i = 1, DUPLIKATIONEN * 10 * 2.5 do
                    pullUpRemote:Fire()
                end
                task.wait(2)
            end
        end)
    end

    local function StrAutoFarm()
        task.spawn(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Modules = ReplicatedStorage:WaitForChild("Modules")
            local BridgeNet = require(Modules:WaitForChild("BridgeNet2"))
            local remote = BridgeNet.ReferenceBridge("imadumbexploiter9d7f88729c2c6ceff3bb1ce223049848")
            local ANZAHL_DUPLIKATIONEN = 150

            while _G.StrAutoFarm do
                for i = 1, ANZAHL_DUPLIKATIONEN * 10 * 2.5 do
                    remote:Fire()
                end
                task.wait(2)
            end
        end)
    end

    local FarmTab = Window:MakeTab({
        Name = "Strength Autofarm",
        Icon = "rbxassetid://74077778", -- corregido
        PremiumOnly = false
    })

    FarmTab:AddToggle({
        Name = "Auto Strength",
        Default = false,
        Callback = function(Value)
            _G.StrAutoFarm = Value
            if Value then
                StrAutoFarm()
            end
        end
    })

    local FarmTab2 = Window:MakeTab({
        Name = "Health Autofarm",
        Icon = "rbxassetid://74077778", -- corregido
        PremiumOnly = false
    })

    FarmTab2:AddToggle({
        Name = "Auto Health",
        Default = false,
        Callback = function(Value)
            _G.AutoHealthFarm = Value
            if Value then
                AutoHealthFarm()
            end
        end
    })

    OrionLib:Init()
end
