CD_Main = {}  --初始化
CD_Main.Version = "1.0"   --版本号
CD_Main.VersionNum = 01000000   --版本号
CD_Main.Path = table.pack(...)[1]  --获取路径

if Game.IsSingleplayer or SERVER then
	dofile(CD_Main.Path .. "/Lua/Scripts/Server/teleport.lua")
	dofile(CD_Main.Path .. "/Lua/Scripts/stuff.lua")
	dofile(CD_Main.Path .. "/Lua/Scripts/Server/cd_cqb_combatinship.lua")
	dofile(CD_Main.Path .. "/Lua/Scripts/Server/shadow.lua")
end

if CLIENT then  --仅客户端
	dofile(CD_Main.Path.."/Lua/Scripts/Client/weapon_zoom.lua")  --编译
	dofile(CD_Main.Path.."/Lua/Scripts/Client/transmogrifier.lua")
end
dofile(CD_Main.Path .. "/Lua/Scripts/Server/revive.lua")
dofile(CD_Main.Path .. "/Lua/Scripts/Server/lockhand.lua")
dofile(CD_Main.Path .. "/Lua/Scripts/Server/personalbox.lua")
dofile(CD_Main.Path .. "/Lua/Scripts/Server/thermalstealth.lua")
dofile(CD_Main.Path .. "/Lua/Scripts/Server/shadowclient.lua")