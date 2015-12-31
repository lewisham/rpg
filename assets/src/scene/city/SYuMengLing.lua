----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：村庄－云梦岭
----------------------------------------------------------------------

local SYuMengLing = class("SYuMengLing", GameScene)


-- 初始化
function SYuMengLing:init()
    --local ret = require("Scene.SAutoUpdate").new()
    --ret:init()
    cc.SimpleAudioEngine:getInstance():playMusic("sound/bgm_battle1.mp3", true)
    StartCoroutine(self, "play")

end

function SYuMengLing:play(co)
    self:createGameObject("prefabs.city.UICity", {filename = "city/YuMengLing.csb"})
end

return SYuMengLing
