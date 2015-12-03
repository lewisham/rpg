----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：怪物状态栏(普通)
----------------------------------------------------------------------
local MStatusBar = class("MStatusBar", Component)

MStatusBar._uiFileName = "Layout/Monster/StatusBar/MonsterStatusBar.csb"

function MStatusBar:init()
    self:loadCsb()
    self:findComponent("ActionSprite"):addChild(self:getRoot())
    local root = self:getRoot()
    -- 默认隐藏
    root:setVisible(false)
    root:setCascadeOpacityEnabled(true)

    root:setPosition(0, 160)
    self:getGameObject():createComponent("StatusBar.LifeBar", {node = self, bReverse = false, bShake = false})
end

function MStatusBar:onShow()
    local root = self:getRoot()
    root:setVisible(true)
    root:setOpacity(255)
    root:stopAllActions()
    local tb = 
    {
        cc.DelayTime:create(2.0),
        cc.FadeOut:create(0.3),
        cc.Hide:create(),
    }
    root:runAction(cc.Sequence:create(tb))
end

return MStatusBar
