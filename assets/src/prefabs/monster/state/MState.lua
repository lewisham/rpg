----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：怪物状态
----------------------------------------------------------------------

local MState = class("MState", Component)

function MState:play(name)
    StartCoroutine(self, "play"..name)
end

-- 击退
function MState:playJiTui(co)
    local node = self:findComponent("ActionSprite")
    local model = node.mModel

    local offx = 250
    if self:findComponent("GroupID") == 1 then
        offx = -offx
    end
    model:playAnimate("hitback", 1)
    node:runAction(cc.EaseOut:create(cc.MoveBy:create(0.1, cc.p(offx, 0)), 2.5))
    WaitForSeconds(co, 0.1)

    WaitForModelAnimate(co, model, "hitwall")
    WaitForModelAnimate(co, model, "hitconver")
    model:playAnimate("hitreset", 0)
    node:runAction(cc.EaseOut:create(cc.MoveBy:create(0.2, cc.p(-offx, 0)), 2.5))
    WaitForSeconds(co, 0.2)

    WaitForModelAnimate(co, model, "situp")
    model:playAnimate("idle", 1)
end

return MState
