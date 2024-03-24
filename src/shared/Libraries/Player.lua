local PlayerUtil = {}

local Player = game.Players.LocalPlayer


function PlayerUtil.IsWalking()
    return Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.MoveDirection.Magnitude > 0
end

return PlayerUtil