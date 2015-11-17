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

function createMonster(id, pos, group)
    local config = monster_config[id]
    local ret = require("Root.Battle.Monster.Monster").new()
    ret:init({config = config, position = pos, group = group})
    Root:findRoot("Camp"):addActor(ret)
    return ret
end

-- 构造函数
function BattleRoot:ctor()
	BattleRoot.super.ctor(self)
end

function BattleRoot:init()
    local root = cc.Layer:create()
	g_RootScene:addChild(root)
	root:setPosition(0, 0)
    g_BattleRoot = root

    require "Root.Battle.Skill.SKDefine"
    require "Data.monster_config"
    self:createChild("Root.Battle.Round.Camp")
    self:createChild("Root.Battle.Mode.Story.SPlayStory")
	--self:createChild("Root.Battle.Mode.ModeEdit")
end

return BattleRoot