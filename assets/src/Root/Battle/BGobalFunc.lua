----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：战斗全局函数
----------------------------------------------------------------------

g_MonsterRoot = nil
g_BattleRoot = nil

function safeRemoveNode(node)
    if not node then return end
    node:removeFromParent(true)
end

function createMonster(id, pos, group, fidx)
    local config = monster_config[id]
    local tb = clone(config)
    tb.model = clone(monster_model[tb.model_id])
    local ret = require("Root.Battle.Monster.Monster").new()
    ret:init({config = tb, position = pos, group = group, fidx = fidx})
    Root:findRoot("Camp"):addActor(ret)
    return ret
end

-- 创建幻象
function createPhantasm(monster)
    local group = monster:getChild("GroupID")
    local places = Root:findRoot("ActionList"):getEmptyPlace(group)
    local list = {}
    for _, idx in pairs(places) do
        local pos = calcFormantionPos(idx, group)
        local ret = createMonster(monster._args.config.id, pos, group, idx)
        Root:findRoot("ActionList"):addActor(ret)
        ret:getChild("MStatusBar"):setVisible(true)
        ret:getChild("ActionSprite"):changeState("idle")
        table.insert(list, ret)
    end
    return list
end

function preloadMonsterRes(id)
    local config = monster_model[monster_config[id].model_id]
    local name = config.model
	local path = "monster/"..name.."/"..name..".ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
end

function calcFormantionPos(id, group)
    local offset = 120
    local list2 = {cc.p(0, 0), cc.p(offset, 0), cc.p(-offset, 0), cc.p(0, -offset), cc.p(0, offset)}
    local list1 = {cc.p(200, 256), cc.p(1024 - 200, 256)}
    return cc.pAdd(list1[group], list2[id])
end
