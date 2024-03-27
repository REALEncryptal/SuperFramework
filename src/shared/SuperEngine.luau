local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SuperEngine = {}
SuperEngine.__index = SuperEngine

export type SuperEngine = {
	DiscoverSuperPower: (self: SuperEngine, SuperPower: ModuleScript) -> SuperEngine
}

function SuperEngine.new()
	local self = setmetatable({}, SuperEngine)

	shared.Assets = game.ReplicatedStorage.Assets

	self.Powers = {}

	return self
end

function SuperEngine:DiscoverSuperPower(Power: ModuleScript): SuperEngine
	print("Discovered SuperPower:", Power.Name)
	local Power = require(Power)
	table.insert(self.Powers, Power)

	return self
end

function SuperEngine:InitPowers(): SuperEngine
	-- sort based on Power.Priority
	table.sort(self.Powers, function(a, b)
		return a.Priority < b.Priority
	end)

	for _, Power in ipairs(self.Powers) do
		Power:Init()
	end

	return self
end

function SuperEngine:Finish(this): SuperEngine

	require(ReplicatedStorage.Shared.Libraries.Librarian):Init(
		{
			ReplicatedStorage.Shared,
			this
		}
	)


	return self
end

return SuperEngine