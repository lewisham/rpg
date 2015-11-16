----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：场景
----------------------------------------------------------------------

local BScene = NodeDef("BScene", "Scene/scene06/scene06_1.csb")

function BScene:init()
    g_BattleRoot:addChild(self)
    g_MonsterRoot = self.ground

    local node = cc.Node:create()
    self:addChild(node)
    node:scheduleUpdateWithPriorityLua(function() self:onReorder() end, 0)

end

-- 对子结点重新排序
function BScene:onReorder()
    Root:findRoot("Camp"):sortZOrder()
    g_MonsterRoot:sortAllChildren()
end

return BScene
