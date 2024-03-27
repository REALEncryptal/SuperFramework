local SoundService = {}

local RblxSoundService = game:GetService("SoundService")

function SoundService:PlaySound(Sound)
    RblxSoundService:PlayLocalSound(Sound)
end

function SoundService:PlayRandomSound(SoundsFolder)
    local Sounds = SoundsFolder:GetChildren()
    local Sound = Sounds[math.random(1, #Sounds)]
    RblxSoundService:PlayLocalSound(Sound)
end

return SoundService