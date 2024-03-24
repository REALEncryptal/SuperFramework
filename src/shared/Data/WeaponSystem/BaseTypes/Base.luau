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

function CreateAnimationTrack(AnimationId, Animator): AnimationTrack
    local AnimationObject = Instance.new("Animation")
    AnimationObject.AnimationId = AnimationId

    return Animator:LoadAnimation(AnimationObject)
end

-- TODO: Make better way to handle default viewmodel animations
local DefaultEquipAnim = ""

local Spring = shared.Import "Spring3"
local PlayerUtil = shared.Import "Player"

local UserInputService = game:GetService("UserInputService")

function BaseTool.new(Data)
    local self = setmetatable({}, BaseTool)

    self.Type = "BaseTool"
    self.ToolData = {
        Equipped = false,
    }

    self.Data = Data
    self.Animations = {}

    self.Offsets = {
        Base = Data.Offsets.Base or CFrame.new(),
    }

    self.Springs = {
        Sway = Spring.new(),
        Bob = Spring.new(),
        Jump = Spring.new(),
    }

    --setup
    self.Viewmodel = Data.Viewmodel or shared.Assets.WeaponSystem.Viewmodels.Default
    self.Animator = self.Viewmodel:WaitForChild("Humanoid"):WaitForChild("Animator")

    -- load animations
    for AnimationName, Animation in pairs(self.Data.Animations) do
        self.Animations[AnimationName] = CreateAnimationTrack(Animation, self.Animator)
    end

    --check defaults
    if not self.Animations["Equip"] then 
        CreateAnimationTrack(DefaultEquipAnim, self.Animator)
    end

    -- connections
    self.Animations["Equip"].Stopped:Connect(function()
        self.Equipped = true
    end)

    return self
end

function BaseTool:Equip()
    self.Animations.Equip:Play()
end

function BaseTool:Unequip()
    self.ToolData.Equipped = false

    self.Animations.Reload:Stop()
    self.Animations.Equip:Stop()

    self.Viewmodel.Parent = game.ReplicatedStorage
end

function BaseTool:FunctionalUpdate(DeltaTime)
    -- implemented by child
end

function BaseTool:Update(DeltaTime)
    -- update
    self:FunctionalUpdate(DeltaTime)

    -- sway
    local MouseDelta = UserInputService:GetMouseDelta()
    self.Springs.Sway.Target = Vector3.new(MouseDelta.X, MouseDelta.Y, 0)

    -- bob
    local Walking = PlayerUtil.IsWalking()

    if Walking then
        self.Springs.Target = Vector3.new(
            math.sin(tick() * 2) * 0.1,
            math.cos(tick() * 4) * 0.1,
            0
        )
    end

    -- update springs
    for _, Spring in pairs(self.Springs) do
        Spring:TimeSkip(DeltaTime)
    end

    -- total offsets
    local TotalOffset = self.Offsets.Base * self.Springs.Sway.Position * self.Springs.Bob.Position * self.Springs.Jump.Position

    -- update viewmodel
    self.Viewmodel:SetPrimaryPartCFrame(TotalOffset)
end

return BaseTool