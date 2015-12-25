-- 对obj添加对应类的方法
function setClass(obj, cls)
    for name, val in pairs(cls) do
        if obj[name] == nil then
            obj[name] = val
        end
    end
end

-- 创建游戏场
function createGameScene(path, name)
    local ret = require(path).new()
    ret:createRoot()
    ret:init()
    return ret
end

function safeRemoveNode(node)
    if not node then return end
    node:removeFromParent(true)
end

-- 初始化全局变量
function initBattleGlobal()
    g_FrontEffectRoot = nil
    g_BackEffectRoot = nil
    g_EffectRootMgr = nil
    g_ActionList =  nil
    g_MonsterRoot = nil
    g_UIScene = nil
end

-- 创建幻象
function createPhantasm(monster, count)
    local group = monster:findComponent("GroupID")
    local places = g_ActionList:getEmptyPlace(group)
    local list = {}
    for key, idx in pairs(places) do
        if key > count then break end
        local pos = calcFormantionPos(idx, group)
        local monster_id = monster._args.config.id
        --monster_id = 10003
        local ret = monster:getScene():createMonster(monster_id, pos, group, idx)
        ret:addComponent("Phantasm", true)
        g_ActionList:addActor(ret)
        --ret:findComponent("MStatusBar"):setVisible(true)
        ret:findComponent("ActionSprite"):changeState("idle")
        table.insert(list, ret)
    end
    return list
end
local mOffsetPos = nil
function calcFormantionPos(id, group)
    if mOffsetPos == nil then
        mOffsetPos = {}
        table.insert(mOffsetPos, cc.p(0, 0))
        local total = 5
        local angle = 30 / 180 * 3.1415926
        local add = 3.1415926 * 2 / total
        local xRadius = 140
        local yRadius = 110
        for i = 1, total do
            local x = math.sin(angle) * xRadius
            local y = math.cos(angle) * yRadius
            table.insert(mOffsetPos, cc.p(x, y))
            angle = angle + add
        end
    end
    local x = (SCENE_MAP_WIDTH - 1024) / 2 + 200
    local list1 = {cc.p(x, SCENE_MAP_MIDDLE_Y), cc.p(SCENE_MAP_WIDTH - x, SCENE_MAP_MIDDLE_Y)}
    local pos = cc.pAdd(list1[1], mOffsetPos[id])
    if group == 2 then
        pos.x = SCENE_MAP_WIDTH / 2 + SCENE_MAP_WIDTH / 2 - pos.x
    end
    return pos
end

-- 镜对移动到
function cameraMoveTo(pos, duration)
    if g_UIScene == nil then return end
    g_UIScene:cameraMoveTo(pos, duration)
end

-- 计算权重的索引
function calcWeightIndex(list)
    local total = 0
    for _, val in ipairs(list) do
        total = total + val
    end
    local r = math.random(1, total)
    for key, val in ipairs(list) do
        if r <= val then
            return key
        end
        r = r - val
    end
    return 1
end