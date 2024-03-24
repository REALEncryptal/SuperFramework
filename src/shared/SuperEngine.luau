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

function SuperEngine:DiscoverSuperPower(self, Power: ModuleScript): SuperEngine
	print("Discovered SuperPower:", Power.Name, "with priority", Power)
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

return SuperEngine