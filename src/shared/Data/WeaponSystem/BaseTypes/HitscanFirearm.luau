local ToolBase = shared.Import "Base"
local Spring = shared.Import "Spring3"
local SoundService = shared.Import "SoundService"
local WeaponNetworkService = shared.Import "WeaponNetworkService"

local HitscanFirearm = setmetatable({}, ToolBase)
HitscanFirearm.__index = HitscanFirearm

function HitscanFirearm.new(Data)
    local self = ToolBase.new(Data)
    setmetatable(self, HitscanFirearm)

    self.Type = "HitscanFirearm"

    self.Network = WeaponNetworkService.new(self)
    
    self.Offsets.Aim = CFrame.new()

    self.Springs.Recoil = Spring.new()

    self.ToolData.ADS = false

    return self
end

function HitscanFirearm:Fire()
    
end

function HitscanFirearm:Reload()
    -- reload logic
end

function HitscanFirearm:ADS(Aim)
    -- TODO: implement ADS logic
    self.ToolData.ADS = Aim
    if Aim then
        return
    else
        return
    end
end


function HitscanFirearm:FunctionalUpdate(DeltaTime)
    -- update logic
end

return HitscanFirearm