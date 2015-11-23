----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：战斗全局函数
----------------------------------------------------------------------

g_MonsterRoot = nil
g_BattleRoot = nil
g_UIScene = nil

function safeRemoveNode(node)
    if not node then return end
    node:removeFromParent(true)
end

-- 创建怪物
function createMonster(id, pos, group, fidx)
    local config = monster_config[id]
    local tb = clone(config)
    tb.model = clone(monster_model[tb.model_id])
    local ret = require("Root.Battle.Monster.Monster").new()
    ret:init({config = tb, position = pos, group = group, fidx = fidx})
    findObject("Camp"):addActor(ret)
    return ret
end

-- 创建幻象
function createPhantasm(monster)
    local group = monster:getChild("GroupID")
    local places = findObject("ActionList"):getEmptyPlace(group)
    local list = {}
    for _, idx in pairs(places) do
        local pos = calcFormantionPos(idx, group)
        local monster_id = monster._args.config.id
        --monster_id = 10003
        local ret = createMonster(monster_id, pos, group, idx)
        ret:addChild("Phantasm", true)
        findObject("ActionList"):addActor(ret)
        ret:getChild("MStatusBar"):setVisible(true)
        ret:getChild("ActionSprite"):changeState("idle")
        table.insert(list, ret)
    end
    return list
end

-- 预加载怪物资源
function preloadMonsterRes(id)
    local config = monster_model[monster_config[id].model_id]
    local name = config.model
	local path = "monster/"..name.."/"..name..".ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
end

-- 阵形位置
SCENE_MAP_WIDTH = 1024
function calcFormantionPos(id, group)
    local offset = 120
    local list2 = {cc.p(0, 0), cc.p(offset, 0), cc.p(-offset, 0), cc.p(0, -offset), cc.p(0, offset)}
    local x = (SCENE_MAP_WIDTH - 1024) / 2 + 200
    local list1 = {cc.p(x, 256), cc.p(SCENE_MAP_WIDTH - x, 256)}
    local pos = cc.pAdd(list1[group], list2[id])
    return pos
end

-- 镜对移动到
function cameraMoveTo(pos, duration)
    if g_UIScene == nil then return end
    g_UIScene:cameraMoveTo(pos, duration)
end
