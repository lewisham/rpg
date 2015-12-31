local SAutoUpdate = class("SAutoUpdate", GameScene)

local sever_url = "https://raw.githubusercontent.com/lewisham/rpg/master/"

function SAutoUpdate:download(filename, callback)
    local url = sever_url..filename
    local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr:open("GET", url)
	local function onReadyStateChange()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then -- 成功
            callback(filename, xhr.response)
		else -- 失败
			callback()
		end
	end
	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send()
	return xhr
end

function SAutoUpdate:fileWrite(filename, str)
    local dir = string.match(filename, "(.+)/[^/]*%.%w+$")
    cc.FileUtils:getInstance():createDirectory(dir)
	local f = io.open(filename, "wb")
	if f then
		f:write(str)
		io.close(f)
	end
end

function SAutoUpdate:init()
    print("SAutoUpdate init")
    -- 清除文件缓存
	cc.FileUtils:getInstance():purgeCachedEntries()
    cc.FileUtils:getInstance():createDirectory(self:getDownloadDir())
    local list = {"assets/sound/fengwuhen_atk1.mp3", "assets/src/Scene/SAutoUpdate.lua"}
    StartCoroutine(self, "play", list)
end

function SAutoUpdate:play(co, list)
    local err = ""
    local function callback(path)
        if path == nil then
            err = "down load error"
        else
            print("down load success", path)
        end
        
        co:resume("waitForFetchOne")
    end

    for _, val in pairs(list) do
        self:fetchOne(val, callback)
        co:pause("waitForFetchOne")
        if err ~= "" then
            print(err)
            break
        end
    end
    return err
end

function SAutoUpdate:fetchOne(filename, handler)
    local function callback(path, str)
        if path == nil then return end
        local path1 = self:getDownloadDir()..path
        self:fileWrite(path1, str)
        handler(path)
    end
    self:download(filename, callback)
end

function SAutoUpdate:getDownloadDir()
	return DOWN_LOAD_PATH
end


return SAutoUpdate
