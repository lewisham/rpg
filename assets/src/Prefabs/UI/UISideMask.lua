----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：上下边黑幕
----------------------------------------------------------------------

local UISideMask = class("UISideMask", GameObject)

local height = 100

function UISideMask:init(duration)
    self:loadCsb()
    local root = self:getRoot()

    local winSize = cc.Director:getInstance():getWinSize()
    local up = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), winSize.width, height)
    root:addChild(up, 1000)
    up:setPosition(0, winSize.height)
    up:runAction(cc.EaseOut:create(cc.MoveBy:create(duration, cc.p(0, -height)), 0.5))
    self.up = up

    local down = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), winSize.width, height)
    root:addChild(down, 1000)
    down:setPosition(0, -height)
    down:runAction(cc.EaseOut:create(cc.MoveBy:create(duration, cc.p(0, height)), 0.5))
    self.down = down
end

function UISideMask:removeFromScene(duration)
    self.up:runAction(cc.EaseIn:create(cc.MoveBy:create(duration, cc.p(0, height)), 2.5))
    self.down:runAction(cc.EaseIn:create(cc.MoveBy:create(duration, cc.p(0, -height)), 2.5))
    local tb =
    {
        cc.DelayTime:create(duration),
        cc.RemoveSelf:create(),
    }
    self:getRoot():runAction(cc.Sequence:create(tb))
end

return UISideMask

