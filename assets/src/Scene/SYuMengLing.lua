----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：村庄－云梦岭
----------------------------------------------------------------------

local SYuMengLing = class("SYuMengLing", GameScene)

-- 初始化
function SYuMengLing:init()
    startCoroutine(self, "play")
end

function SYuMengLing:play(co)
    self:createGameObject("Prefabs.UI.UICity", {filename = "City/YuMengLing.csb"})
    self:createGameObject("Prefabs.UI.UICityMainPanel")
end

return SYuMengLing
