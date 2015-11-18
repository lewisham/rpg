----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：场景
----------------------------------------------------------------------

local UIScene = NodeDef("UIScene", "Scene/scene06/scene06_1.csb")

function UIScene:init()
    self:onCreate()
    g_BattleRoot:addChild(self)
    g_MonsterRoot = self.ground
    self:initParallaxNode()
    
    local node = cc.Node:create()
    self:addChild(node)
    node:scheduleUpdateWithPriorityLua(function() self:onReorder() end, 0)
    createObject("Root.Battle.Skill.Effect.EffectRootMgr")
end

-- 初始化不同层级移动速度不同结点
function UIScene:initParallaxNode()
    local parallaxNode = cc.ParallaxNode:create()
	self:addChild(parallaxNode)
    self.mParallaxNode = parallaxNode

    local size = self.ground:getContentSize()
    local winSize = cc.Director:getInstance():getWinSize()
    local tb = {"front", "ground", "back", "sky"}
    local list = {}
    for _, name in pairs(tb) do
        local unit = {}
        unit.name = name
        unit.node = self[name]
		unit.scale = (unit.node:getContentSize().width - winSize.width) / (size.width - winSize.width)
        table.insert(list, unit)
	end

    for idx, unit in pairs(list) do
        local layer = cc.Node:create()
        local node = unit.node
        node:retain()
        node:removeFromParent(false)
        parallaxNode:addChild(layer, 4 - idx, cc.p(unit.scale, 1.0), cc.p(0, 0))
        layer:addChild(node)
        node:release()
    end

    -- max
    local width = size.width - cc.Director:getInstance():getWinSize().width
end

function UIScene:cameraMoveTo(pos, duration)
    self.mParallaxNode:stopAllActions()
	local act1 = cc.EaseIn:create(cc.MoveTo:create(duration, pos), 1.0)
	self.mParallaxNode:runAction(act1)
end

function UIScene:setPosition(x, y)
    self.mParallaxNode:setPosition(x, y)
end

-- 对子结点重新排序
function UIScene:onReorder()
    Root:findRoot("Camp"):sortZOrder()
    g_MonsterRoot:sortAllChildren()
end

return UIScene
