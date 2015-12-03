----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：武装护运
----------------------------------------------------------------------

local SEscortAgency = class("SEscortAgency", Root)

-- 初始化
function SEscortAgency:init(args)
    startCoroutine(self, "play")
    self.mPlayerMonsters = {}
    self.mEnemyMonsters = {}
end

-- 开始执行逻辑
function SEscortAgency:play(co)
    local list = {}
    -- 进场
    self:createComponent("Root.Battle.UI.UILoading", {10001, 10002, 10003, 10004})
    co:waitForFuncResult(function() return self:findComponent("UILoading"):isDone() end)
    self:removeChild("UILoading")
    self:createComponent("Root.Battle.Round.Camp")
    self:createComponent("Root.Battle.UI.UIScene")
    self:createComponent("Root.Battle.Skill.Effect.EffectRootMgr")
    self:createComponent("Root.Battle.UI.UIPlaceName", "押镖途中")
    self:initPlayerMonsters()
    self:initEnemyMonsters()
    self:playFighting(co)
end

function SEscortAgency:initPlayerMonsters()
    local m1 = createMonster(10003, calcFormantionPos(1, 1), 1, 1)
    local m2 = createMonster(10005, calcFormantionPos(2, 1), 1, 2)
    self.mPlayerMonsters = {m1, m2}
end

-- 初始化数据
function SEscortAgency:initEnemyMonsters()
    local list = {10004, 10004, 10004}
    for key, id in pairs(list) do
        local idx = key
        local pos = calcFormantionPos(idx, 2)
        local m1 = createMonster(id, pos, 2, idx)
        m1:addChild("KnockOutType", 1)
        table.insert(self.mEnemyMonsters, m1)
    end
end

-- 战斗
function SEscortAgency:playFighting(co)
    self:findComponent("UIScene"):cameraMoveTo(0, 0.1)
    co:waitForSeconds(0.2)
    self:createComponent("Root.Battle.Round.ActionList")
    for _, val in pairs(self.mPlayerMonsters) do
        findObject("ActionList"):addActor(val)
    end
    for _, val in pairs(self.mEnemyMonsters) do
        findObject("ActionList"):addActor(val)
    end
    co:waitForFuncResult(function() return self:findComponent("ActionList"):isBattleEnd() end)
    self:removeChild("ActionList")
end

return SEscortAgency