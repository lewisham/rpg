----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：战斗根结点
----------------------------------------------------------------------

local BattleRoot = class("BattleRoot", Root)

BattleRoot.ROOT_PATH = "Root.Battle"

-- 构造函数
function BattleRoot:ctor()
	BattleRoot.super.ctor(self)
end

function BattleRoot:init()
    require "Root.Battle.Skill.SKDefine"
    require "Root.Battle.BGobalFunc"
    require "Data.monster_config"
    require "Data.monster_model"

    local root = cc.Layer:create()
	g_RootScene:addChild(root)
	root:setPosition(0, 0)
    g_BattleRoot = root
    math.randomseed(os.clock())
    self:createScene("Root.Battle.Scene.SOpeningCG")
	--self:createScene("Root.Battle.Scene.SMonsterEdit")
end

return BattleRoot