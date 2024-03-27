local SuperEngine = require(game:GetService("ReplicatedStorage").Shared.SuperEngine).new()

local SuperPowers = script.SuperPowers

for _, Power in ipairs(SuperPowers:GetChildren()) do
    SuperEngine:DiscoverSuperPower(Power)
end 

SuperEngine
    :Finish(script)
    :InitPowers()
