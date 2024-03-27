local Data = {}

Data.Viewmodel = shared.Assets.WeaponSystem.Viewmodels.Default

Data.Animations = {
    Equip = "rbxassetid://16885454590",
    Reload ="rbxassetid://16885454590",
    Fire = "rbxassetid://16885454590",
    Idle = "rbxassetid://16885454590"
}

Data.Offsets = {
    Base = CFrame.new(0, -1, 0),    
    Aim = CFrame.new(),
}

return Data