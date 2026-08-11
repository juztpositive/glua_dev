AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
print('[Chainsaw] Начата загрузка серверной части')

concommand.Add("testttttttt",function (ply)
	print('t')
end)

print('[Chainsaw] Конец загрузки серверной части')
