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

function SAutoUpdate:fileWrite(fileName, str)
	local f = io.open(fileName, "wb")
	if f then
		f:write(str)
		io.close(f)
	end
end

function SAutoUpdate:init()
    -- 清除文件缓存
	cc.FileUtils:getInstance():purgeCachedEntries()
    cc.FileUtils:getInstance():createDirectory(self:getDownloadDir())
    self:fetchOne("assets/sound/fengwuhen_atk1.mp3")
end

function SAutoUpdate:fetchOne(filename)
    local function callback(path, str)
        if path == nil then return end
        path = self:getDownloadDir()..path
        print(path)
        self:fileWrite(path, str)
    end
    self:download(filename, callback)
end

function SAutoUpdate:getDownloadDir()
	return cc.FileUtils:getInstance():getWritablePath()..'download/'
end


return SAutoUpdate
