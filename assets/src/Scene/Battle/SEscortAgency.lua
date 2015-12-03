----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：武装护运
----------------------------------------------------------------------

local SEscortAgency = class("SEscortAgency", GameScene)

-- 初始化
function SEscortAgency:init(args)
    require "Prefabs.Skill.SKDefine"
    require "Data.monster_config"
    require "Data.monster_model"
    initBattleGlobal()
    self.mPlayerMonsters = {}
    self.mEnemyMonsters = {}
    startCoroutine(self, "play")
end

-- 开始执行逻辑
function SEscortAgency:play(co)
    self:createGameObject("Prefabs.UI.UILoading", {10001, 10002, 10003, 10004}):play(co)
    self:removeGameObject("UILoading")

    self:createGameObject("Prefabs.Round.Camp")
    self:createGameObject("Prefabs.UI.UIScene")
    self:createGameObject("Prefabs.Skill.Effect.EffectRootMgr")
    self:createGameObject("Prefabs.UI.UIPlaceName", "押镖途中")
    co:waitForSeconds(2.5)

    self:initPlayerMonsters()
    self:initEnemyMonsters()
    self:playFighting(co)
    co:waitForSeconds(1.5)
    Player:getInstance():goHome()
end

function SEscortAgency:initPlayerMonsters()
    local m1 = self:createMonster(10003, calcFormantionPos(1, 1), 1, 1)
    local m2 = self:createMonster(10005, calcFormantionPos(2, 1), 1, 2)
    self.mPlayerMonsters = {m1, m2}
end

-- 初始化数据
function SEscortAgency:initEnemyMonsters()
    local list = {10004, 10004, 10004, 10004, 10004, 10004}
    for key, id in pairs(list) do
        local idx = key
        local pos = calcFormantionPos(idx, 2)
        local m1 = self:createMonster(id, pos, 2, idx)
        table.insert(self.mEnemyMonsters, m1)
    end
end

-- 创建怪物
function SEscortAgency:createMonster(id, pos, group, fidx)
    local config = monster_config[id]
    local tb = clone(config)
    tb.model = clone(monster_model[tb.model_id])
    local args = {config = tb, position = pos, group = group, fidx = fidx}
    local ret = self:createGameObject("Prefabs.Monster.Monster", args)
    self:findGameObject("Camp"):addActor(ret)
    return ret
end

-- 战斗
function SEscortAgency:playFighting(co)
    self:findGameObject("UIScene"):cameraMoveTo(0, 0.1)
    co:waitForSeconds(0.2)
    self:createGameObject("Prefabs.Round.ActionList")
    for _, val in pairs(self.mPlayerMonsters) do
        self:findGameObject("ActionList"):addActor(val)
    end
    for _, val in pairs(self.mEnemyMonsters) do
        self:findGameObject("ActionList"):addActor(val)
    end
    co:waitForFuncResult(function() return self:findGameObject("ActionList"):isBattleEnd() end)
    self:removeGameObject("ActionList")
end

return SEscortAgency