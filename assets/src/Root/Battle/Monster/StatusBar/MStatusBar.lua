----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：怪物状态栏(普通)
----------------------------------------------------------------------

local MStatusBar = NodeDef("MStatusBar", "Layout/Monster/StatusBar/MonsterStatusBar.csb")

function MStatusBar:init(args)
    Common.setClass(self, Child)
    local root = self:getBrother("ActionSprite")
    root:addChild(self)
    self:setPosition(0, 160)
    self:createBrother("StatusBar.LifeBar", {node = self, bReverse = false, bShake = false})
end

return MStatusBar
