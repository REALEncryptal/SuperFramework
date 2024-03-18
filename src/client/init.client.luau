local SuperEngine = require(game:GetService("ReplicatedStorage").Shared.SuperEngine).new()

local SuperPowers = script.SuperPowers

SuperEngine
    :DiscoverSuperPower(SuperPowers.WeaponController)
    :InitPowers()