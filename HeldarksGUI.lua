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
    local KillAura = false

    local function AutoHealthFarm()
        task.spawn(function()
            print("AutoHealthFarm started")
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
            print("StrAutoFarm started")
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
        Name = "Autofarm",
        Icon = "rbxassetid://74077778",
        PremiumOnly = false
    })

    FarmTab:AddToggle({
        Name = "Auto Strength",
        Default = false,
        Callback = function(Value)
            print("Toggle Strength: ", Value)
            _G.StrAutoFarm = Value
            if Value then
                StrAutoFarm()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Auto Health",
        Default = false,
        Callback = function(Value)
            print("Toggle Health: ", Value)
            _G.AutoHealthFarm = Value
            if Value then
                AutoHealthFarm()
            end
        end
    })

    local FarmTab1 = Window:MakeTab({
        Name = "Autofarm",
        Icon = "rbxassetid://74077778",
        PremiumOnly = false
    })

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local killAuraEnabled = false
local killAuraRange = 15

local FarmTab1 = Window:MakeTab({
    Name = "Autofarm",
    Icon = "rbxassetid://74077778",
    PremiumOnly = false
})

FarmTab1:AddToggle({
    Name = "Kill Aura",
    Default = false,
    Callback = function(Value)
        killAuraEnabled = Value

        if Value then
            task.spawn(function()
                while killAuraEnabled do
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if dist <= killAuraRange then
                                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                if humanoid and humanoid.Health > 0 then
                                    humanoid.Health = 0
                                end
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
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

local AntiLagEnabled = false

FarmTab2:AddToggle({
    Name = "AntiLag",
    Default = false,
    Callback = function(Value)
        AntiLagEnabled = Value

        game.Workspace:WaitForChild("Trees"):Destroy()
        
    end
})

local player = game.Players.PlayerAdded
local Character = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local KickEnabled = false


FarmTab2:AddToggle({
    Name = "Kick players",
    Default = false,
    Callback = function(Value)
        KickEnabled = Value  

        if player and Character == true then
            
            player.Kick()

        end 
    end  
})

    

    OrionLib:Init()
end
