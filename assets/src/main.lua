cc.FileUtils:getInstance():addSearchPath("src");
cc.FileUtils:getInstance():addSearchPath("res");


local target = cc.Application:getInstance():getTargetPlatform();


TRACKBACK_HANDDLER = nil
require ("GameApp")

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
    cc.Director:getInstance():pause()
    if TRACKBACK_HANDDLER then
    	TRACKBACK_HANDDLER()
    end
    return msg
end

local status, msg = xpcall(GameApp.applicationDidFinishLaunching, __G__TRACKBACK__)
if not status then
    error(msg)
end