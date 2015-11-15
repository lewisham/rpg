
g_RootScene = nil

GameApp = {}

function GameApp.applicationDidFinishLaunching()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
   
    --print("Writable path:"..cc.FileUtils:getInstance():getWritablePath())
    --print("SearchPaths:\n\t"..table.concat(cc.FileUtils:getInstance():getSearchPaths(),"\n\t"));

    package.loadedSystem = {}
    for c,v in pairs(package.loaded) do
        package.loadedSystem[c] = true
    end
    package.loadedSystem["GameApp"] = nil
	
	cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1024, 576, 2)
	g_RootScene = cc.Scene:create()
	cc.Director:getInstance():runWithScene(g_RootScene)
    cc.FileUtils:getInstance():setPopupNotify(false)
    cc.Director:getInstance():setDisplayStats(true)
    
	require "cocos.init"
	require "core.init"
	
	local cls = require("Root.Battle.BattleRoot")
	local ret = cls.new()
	ret:init()

end

function GameApp.applicationWillEnterForeground()
    -- body
    if ENTER_FOREGROUND_HANDLER then
        ENTER_FOREGROUND_HANDLER();
    end
    if ENTER_FOREGROUND_SYNC then
        ENTER_FOREGROUND_SYNC();
    end
end

function GameApp.applicationDidEnterBackground( ... )
    -- body
end

function GameApp.applicationWillExit()
    print("application exit")
end


function GameApp.applicationClearCache()
end



function GameApp.applicationStartGame()
end
