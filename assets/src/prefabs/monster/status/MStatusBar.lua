----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：怪物状态栏(普通)
----------------------------------------------------------------------
local MStatusBar = NodeDef("MStatusBar", "Layout/Monster/StatusBar/MonsterStatusBar.csb")

function MStatusBar:init()
    self.mbAutoAddTo = false
    self:onCreate()
    self:findComponent("ActionSprite"):addChild(self)
    -- 默认隐藏
    self:setVisible(false)
    self:setCascadeOpacityEnabled(true)

    self:setPosition(0, 160)
    self:getGameObject():createComponent("status.LifeBar", {node = self, bReverse = false, bShake = false})
end

function MStatusBar:onShow()
    self:setVisible(true)
    self:setOpacity(255)
    self:stopAllActions()
    local tb = 
    {
        cc.DelayTime:create(2.0),
        cc.FadeOut:create(0.3),
        cc.Hide:create(),
    }
    self:runAction(cc.Sequence:create(tb))
end

return MStatusBar
