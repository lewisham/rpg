----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：地方名
----------------------------------------------------------------------

local UIPlaceName = NodeDef("UIPlaceName", "Layout/CG/PlaceName.csb")

function UIPlaceName:init(name)
    self:onCreate()
    g_BattleRoot:addChild(self)
    self.name:setString(name)
    self:setCascadeOpacityEnabled(true)
    self:setOpacity(0)

    local winSize = cc.Director:getInstance():getWinSize()
    self:setPosition(winSize.width / 2, winSize.height / 2 + 150)

    local tb = 
    {
        cc.FadeIn:create(0.3),
        cc.DelayTime:create(1.5),
        cc.FadeOut:create(0.2),
        cc.RemoveSelf:create(),
    }
    self:runAction(cc.Sequence:create(tb))
end

return UIPlaceName
