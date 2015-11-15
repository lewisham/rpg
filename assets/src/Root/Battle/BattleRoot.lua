----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：战斗
----------------------------------------------------------------------

local BattleRoot = class("BattleRoot", Root)

BattleRoot.ROOT_PATH = "Root.Battle"

g_MonsterRoot = nil
g_BattleRoot = nil

function safeRemoveNode(node)
    if not node then return end
    node:removeFromParent(true)
end

-- 构造函数
function BattleRoot:ctor()
	BattleRoot.super.ctor(self)
end

function BattleRoot:init()
    require "Root.Battle.Skill.SKDefine"
    require "Data.monster_config"
	self:createChild("Root.Battle.Mode.ModeEdit")
end

return BattleRoot