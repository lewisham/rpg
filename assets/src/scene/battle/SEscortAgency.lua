----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：武装护运
----------------------------------------------------------------------

local SEscortAgency = class("SEscortAgency", GameScene)

-- 初始化
function SEscortAgency:init(args)
    require "Data.monster_config"
    require "Data.monster_model"
    require "Data.escort_config"
    InitBattleGlobal()
    self.mPlayerMonsters = {}
    self.mEnemyMonsters = {}
    self.config = escort_config[1001]
    StartCoroutine(self, "play")
end

-- 开始执行逻辑
function SEscortAgency:play(co)
    self:createGameObject("Prefabs.UI.UILoading", {10001, 10002, 10003, 10004}):play(co)
    self:removeGameObject("UILoading")

    self:createGameObject("Prefabs.UI.UIScene", self.config.scene_name)
    self:createGameObject("Prefabs.UI.UIPlaceName", "押镖途中")
    WaitForSeconds(co, 2.5)

    self:createGameObject("Prefabs.Skill.SkillMgr")
    self:createGameObject("Prefabs.Round.Camp")

    self:initPlayerMonsters()
    self:initEnemyMonsters()
    self:findGameObject("UIScene"):cameraMoveTo(0, 0.1)
    WaitForSeconds(co, 0.2)
    self:playFighting(co)
    WaitForSeconds(co, 1.5)
    self:removeGameObject("UIScene")
    self:removeGameObject("EffectRootMgr")
    self:removeGameObject("Camp")
    Player:getInstance():goHome()
end

function SEscortAgency:initPlayerMonsters()
    local m1 = self:createMonster(10003, calcFormantionPos(1, 1), 1, 1)
    local m2 = self:createMonster(10005, calcFormantionPos(2, 1), 1, 2)
    self.mPlayerMonsters = {m1, m2}
end

-- 初始化数据
function SEscortAgency:initEnemyMonsters()
    local config = self.config
    local count = config.count[calcWeightIndex(config.count_weight)]
    local list = {}
    for i = 1, count do
        local id = config.monster[calcWeightIndex(config.monster_weight)]
        table.insert(list, id)
    end
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
    self:createGameObject("Prefabs.Round.ActionList")
    for _, val in pairs(self.mPlayerMonsters) do
        self:findGameObject("ActionList"):addActor(val)
    end
    for _, val in pairs(self.mEnemyMonsters) do
        self:findGameObject("ActionList"):addActor(val)
    end
    WaitForFuncResult(co, function() return self:findGameObject("ActionList"):isBattleEnd() end)
    self:removeGameObject("ActionList")
end

return SEscortAgency