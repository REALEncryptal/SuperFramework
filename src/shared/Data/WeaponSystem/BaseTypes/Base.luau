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
local SoundService = shared.Import "SoundService"

local UserInputService = game:GetService("UserInputService")


function BaseTool.new(Data)
    local self = setmetatable({}, BaseTool)

    self.Type = "BaseTool"
    self.ToolData = {
        Equipped = false,
    }

    self.Data = require(Data)
    self.Animations = {}

    self.Offsets = {
        Base = self.Data.Offsets.Base or CFrame.new(),
    }

    self.Springs = {
        Sway = Spring.new(5, 50, 6, 4),
        Bob = Spring.new(),
        Jump = Spring.new(),
    }

    --setup
    self.Viewmodel = self.Data.Viewmodel or shared.Assets.WeaponSystem.Viewmodels.Default
    self.Viewmodel = self.Viewmodel:Clone()
    self.Viewmodel.Parent = game.Workspace.CurrentCamera

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

    self.Animations.Idle:Play()


    return self
end

function BaseTool:Equip()
    self.Animations.Equip:Play()
    SoundService:PlayRandomSound(shared.Assets.WeaponSystem.Sounds.Equip)
end

function BaseTool:Unequip()
    self.ToolData.Equipped = false

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
    local MouseDelta = UserInputService:GetMouseDelta() / 100
    self.Springs.Sway:Shove(Vector3.new(MouseDelta.X, MouseDelta.Y, 0))

    -- bob
    local Walking = PlayerUtil.IsWalking()

    if Walking then
        local TimeMult = 3
        self.Springs.Bob:Shove(Vector3.new(
            math.sin(tick() * 2*TimeMult) * 0.07,
            math.cos(tick() * 4*TimeMult) * 0.1,
            0
        ))
    end

    -- total offsets

    local TotalOffset = Vector3.new()

    for _, Spring in pairs(self.Springs) do
        TotalOffset += Spring:Update(DeltaTime)
    end

    -- update viewmodel
    self.Viewmodel:SetPrimaryPartCFrame(workspace.CurrentCamera.CFrame * self.Offsets.Base)
    self.Viewmodel.PrimaryPart.CFrame *= CFrame.new(TotalOffset)
end

return BaseTool