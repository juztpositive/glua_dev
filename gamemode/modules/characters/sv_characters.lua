AddCSLuaFile()

Chainsaw.characters = {}

--class
Character = {
	name = "",
	surname = "",
	description = "",
	scale = 1,
	model = "",
	bodygroups = "",
	race = "Creation",
}

function Character:new(steamid)
	local obj = {}
	setmetatable(obj, {__index = Character})

	obj.steamid = steamid
	obj.name = self.name
	obj.surname = self.surname
	obj.description = self.description
	obj.scale = self.scale
	obj.model = self.model
	obj.bodygroups = self.bodygroups
	obj.race = self.race

	return obj
end
