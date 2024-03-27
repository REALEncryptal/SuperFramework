local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponController

WeaponController = {
    Priority = 1
}

local WeaponBase

function WeaponController:Init()
    WeaponBase = shared.Import "HitscanFirearm"
    local Weapon = WeaponBase.new(ReplicatedStorage.Shared.Data.WeaponSystem.Weapons.HitscanTemplate)
    Weapon:Equip()
    print("WeaponController initialized")

    game:GetService("RunService").RenderStepped:Connect(function(...)
        Weapon:Update(...)
    end)
end

return WeaponController