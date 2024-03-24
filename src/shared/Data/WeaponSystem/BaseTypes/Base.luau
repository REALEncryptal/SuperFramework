local BaseTool = {}
BaseTool.__index = BaseTool

--[[

    BaseTool
    Authored by: Encryptal

    BaseTool is the base class for all tools in the game.

    Some shared methods and properties include:
    - Type: string -> The type of the tool.
    - ToolData: table -> The data of the tool.
    - Data: table -> The current stats of the tool (bullets, mags).
    - Animations: table[AnimationObject] -> The animations of the tool.
    - Equipped: boolean -> Whether the tool is equipped or not.

    2024-03-20

]]

function BaseTool.new(Data)
    local self = setmetatable({}, BaseTool)

    self.Type = "BaseTool"
    self.ToolData = {}

    self.Data = Data
    self.Animations = {}

    self.Equipped = true

    --setup

    self.Viewmodel = Data.Viewmodel or shared.Assets.WeaponSystem.Viewmodels.Default

    -- load animations
    


    return self
end

return BaseTool