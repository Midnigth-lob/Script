-- Rokarate Gui

if game.PlaceId == 17072376063 then
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "HelDark Ro-Karate Script", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

_G.StrAutoFarm = true,
_G AutoHealthFarm = true

local function AutoHealthFarm()

    -- 𝐇𝐞𝐥𝐃𝐚𝐫𝐤𝐬 - VIDA 😛🧬

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Modules = ReplicatedStorage:WaitForChild("Modules")
    local BridgeNet = require(Modules:WaitForChild("BridgeNet2"))

    local pullUpRemote = BridgeNet.ReferenceBridge("imadumbexploiter3527d36bd7d656f96a836f1df5085590")

    local DUPLIKATIONEN = 150

    while true do
        for i = 1, DUPLIKATIONEN * 10 * 2.5 do
            pullUpRemote:Fire()
        end
        task.wait(2)
    end

    
end

local function StrAutoFarm()
    
end

    -- 𝐇𝐞𝐥𝐃𝐚𝐫𝐤𝐬 - FUERZA 😛🧬


    while _G.StrAutoFarm == true do

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Modules = ReplicatedStorage:WaitForChild("Modules")
        local BridgeNet = require(Modules:WaitForChild("BridgeNet2"))

        local remote = BridgeNet.ReferenceBridge("imadumbexploiter9d7f88729c2c6ceff3bb1ce223049848")

        local ANZAHL_DUPLIKATIONEN = 150

        while true do
            for i = 1, ANZAHL_DUPLIKATIONEN * 10 * 2.5 do
                remote:Fire()
        end
    task.wait(2)
end
    end

        local FarmTab = Window:MakeTab({
        Name = "Strength Autofarm",
        Icon = "rbxassetid:/74077778",
        PremiumOnly = false
    })

    FarmTab:AddToggle({
        Name = "Auto Strength",
        Default = false,
        CallBack = function(Value)
            _G.StrAutoFarm = Value
            StrAutoFarm()

        end
    })

    local FarmTab2 = Window:MakeTab({
        Name = "Health Autofarm",
        Icon = "rbxassetid:/74077778",
        PremiumOnly = false
    })

    FarmTab2:AddToggle({
        Name = "Auto Health",
        Default = false,
        CallBack = function(value)
            _G.AutoHealthFarm = value
            AutoHealthFarm()
            
        end
    })

OrionLib:Init()
end
