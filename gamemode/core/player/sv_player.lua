function GM:PlayerInitialSpawn(ply)
	local data = Chainsaw.database.getData("users", "*", "steamid", "'".. ply:SteamID() .."'")
end
