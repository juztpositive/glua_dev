GM.Team = "juzt positive"
GM.Name = "Tests"
GM.Author = "juzt positive"
Chainsaw = Chainsaw or {}

DeriveGamemode("sandbox")
print("[Chainsaw] Начало 'shared' загрузки")

local function AddFile(File, dir)
    local fileSide = string.lower(string.Left(File, 3))

    if fileSide == "sv_" then
		if SERVER then
	        include(dir..File)
			print("[Chainsaw] Loaded server file: " .. File)
		end
    elseif fileSide == "sh_" then
        if SERVER then
            AddCSLuaFile(dir..File)
            print("[Chainsaw] AddCSLua shared file: " .. File)
        end
        include(dir..File)
        print("[Chainsaw] Loaded shared file: " .. File)
    elseif fileSide == "cl_" then
        if SERVER then
            AddCSLuaFile(dir..File)
            print("[Chainsaw] AddCSLua client file: " .. File)
        else
            include(dir..File)
            print("[Chainsaw] Loaded client file: " .. File)
        end
    else
		if SERVER then
            AddCSLuaFile(dir..File)
            print("[Chainsaw] AddCSLua shared file: " .. File)
        end
        include(dir..File)
        print("[Chainsaw] Loaded shared file: " .. File)
	end
end

local function IncludeDir(dir)
    dir = dir .. "/"
    local File, Directory = file.Find(dir.."*", "LUA")

    for k, v in ipairs(File) do
        if string.EndsWith(v, ".lua") then
            AddFile(v, dir)
        end
    end

    for k, v in ipairs(Directory) do
		print("[Chainsaw] Start loading directory: " .. v)
        IncludeDir(dir..v)
		print("[Chainsaw] End loading directory: " .. v)
    end
end

IncludeDir("chainsawman/gamemode/lib")
IncludeDir("chainsawman/gamemode/database")
IncludeDir("chainsawman/gamemode/player_class")
IncludeDir("chainsawman/gamemode/core")
IncludeDir("chainsawman/gamemode/modules")

print("[Chainsaw] Загрузка 'shared' закончена")
