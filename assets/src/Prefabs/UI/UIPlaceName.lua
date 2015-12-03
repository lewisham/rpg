----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：地方名
----------------------------------------------------------------------

local UIPlaceName = class("UIPlaceName", GameObject)

function UIPlaceName:init(name)
    self:loadCsb("Layout/CG/PlaceName.csb")
    self.name:setString(name)
    local root = self:getRoot()
    root:setCascadeOpacityEnabled(true)
    root:setOpacity(0)

    local winSize = cc.Director:getInstance():getWinSize()
    root:setPosition(winSize.width / 2, winSize.height / 2 + 150)

    local tb = 
    {
        cc.FadeIn:create(0.3),
        cc.DelayTime:create(1.5),
        cc.FadeOut:create(0.2),
        cc.RemoveSelf:create(),
    }
    root:runAction(cc.Sequence:create(tb))
end

return UIPlaceName
