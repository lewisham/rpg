----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏开场CG
----------------------------------------------------------------------

local SOpeningCG = class("SOpeningCG", GameScene)

-- 初始化
function SOpeningCG:init(args)
    require "Prefabs.Skill.SKDefine"
    require "Data.monster_config"
    require "Data.monster_model"
    initBattleGlobal()
    startCoroutine(self, "play")
end

-- 开始执行逻辑
function SOpeningCG:play(co)
    self.mCoroutine = co
    -- 进场
    self:createGameObject("Prefabs.UI.UILoading", {10001, 10002, 10003, 10004}):play(co)
    self:removeGameObject("UILoading")
    self:createGameObject("Prefabs.UI.UIFStory"):play(co)
    self:createGameObject("Prefabs.Round.Camp")
    self:createGameObject("Prefabs.UI.UIScene")
    self:createGameObject("Prefabs.Skill.Effect.EffectRootMgr")
    self:removeGameObject("UIFStory")
    self:createGameObject("Prefabs.UI.UIPlaceName", "云梦岭郊外")
    co:waitForSeconds(2.5)

    cc.SimpleAudioEngine:getInstance():playMusic("sound/bgm_cg1.mp3", true)

    -- 创建主角与大反派
    local m1 = self:createMonster(10001, cc.p(-200, 256), 2, 1)
    m1:findComponent("ActionSprite"):onSword(true)
    m1:findComponent("ActionSprite"):onDir(1)
    co:waitForMonsterMoveTo(m1, calcFormantionPos(1, 2), 1.8, "cast")
    co:waitForSeconds(0.4)
    m1:findComponent("ActionSprite"):onSword(false)
    m1:findComponent("ActionSprite"):onDir(-1)

    local m2 = self:createMonster(10002, cc.p(-200, 256), 1, 1)
    m2:findComponent("ActionSprite"):onSword(true)
    co:waitForMonsterMoveTo(m2, calcFormantionPos(1, 1), 0.8, "idle")
    co:waitForSeconds(0.4)
    m2:findComponent("ActionSprite"):onSword(false)
    m2:findComponent("ActionSprite"):changeState("cast")

    self:cameraMoveTo(0, 0.5)
    self:createGameObject("Prefabs.UI.UISideMask", 0.6)
    co:waitForSeconds(0.6 + 0.8)

    -- 播放剧情1001
    self:playStory(1001, {m1, m2})
    self:removeGameObject("UISideMask", 0.4)
    co:waitForSeconds(0.4 + 0.3)
    -- 开始战斗
    self:playFighting(co, {m1, m2})
    co:waitForSeconds(1.0)
    -- 播放剧情1002
    self:playStory(1002, {m1, m2})
    m2:findComponent("ActionSprite"):onSword(true)
    m2:findComponent("ActionSprite"):onDir(-1)
    co:waitForSeconds(0.5)
    co:waitForMonsterMoveTo(m2, cc.p(-300, 256), 0.8, "cast")
    m2:removeFromScene()
    m2 = nil

    self:playStory(1003, {m1})
    self:cameraMoveTo(-1, 0.8)

    -- 创建狼
    local m3 = self:createMonster(10004, cc.p(-200, 356), 1, 4)
    co:waitForMonsterMoveTo(m3, calcFormantionPos(5, 1), 1.8, "move")
    local m4 = self:createMonster(10004, cc.p(-200, 156), 1, 5)
    co:waitForMonsterMoveTo(m4, calcFormantionPos(4, 1), 1.8, "move")
    self:cameraMoveTo(0, 0.8)
    self:playStory(1004, {m1, m3, m4})

    m1:findComponent("ActionSprite"):onDir(1)
    co:waitForMonsterMoveTo(m1, calcFormantionPos(2, 2), 0.3, "idle")
    m1:findComponent("ActionSprite"):changeState("dead")
    m1:findComponent("ActionSprite"):onDir(-1)

    local m5 = self:createMonster(10003, calcFormantionPos(1, 2), 2, 1)
    self:playAnimate(co, m5, "enter")

    self:playFighting(co, {m3, m4, m5})
    local pos = calcFormantionPos(1, 2)
    co:waitForMonsterMoveTo(m5, cc.p(pos.x - 200, pos.y), 0.3, "idle")
    self:cameraMoveTo(1, 0.8)
    m5:findComponent("ActionSprite"):onDir(1)

    self:createGameObject("Prefabs.UI.UISideMask", 0.6)
    co:waitForSeconds(0.6 + 0.1)

    self:playStory(1005, {m1, m5})
    Player:getInstance():goHome()
end

-- 创建怪物
function SOpeningCG:createMonster(id, pos, group, fidx)
    local config = monster_config[id]
    local tb = clone(config)
    tb.model = clone(monster_model[tb.model_id])
    local args = {config = tb, position = pos, group = group, fidx = fidx}
    local ret = self:createGameObject("Prefabs.Monster.Monster", args)
    self:findGameObject("Camp"):addActor(ret)
    return ret
end

local SPEAKER_DURATION = 1.1

-- 镜头移动
function SOpeningCG:cameraMoveTo(posType, duration)
    self:findGameObject("UIScene"):cameraMoveTo(posType, duration)
    self.mCoroutine:waitForSeconds(duration)
end

-- 播放剧情
function SOpeningCG:playStory(id, monsters)
    require("Data.story_config")
    local list = story_config[id]
    for _, val in pairs(list) do
        local monster = monsters[val.idx]
        monster:speak(val.words)
        self.mCoroutine:waitForSeconds(SPEAKER_DURATION)
        monster:speak(nil)
    end
end

-- 战斗
function SOpeningCG:playFighting(co, monsters)
    self:createGameObject("Prefabs.Round.ActionList")
    for _, val in pairs(monsters) do
        self:findGameObject("ActionList"):addActor(val)
    end
    co:waitForFuncResult(function() return self:findGameObject("ActionList"):isBattleEnd() end)
    self:removeGameObject("ActionList")
end

function SOpeningCG:playAnimate(co, monster, name)
    -- 动作完毕回调
    local function animateEndHandler()
        co:resume("playAnimate")
    end
    monster:findComponent("ActionSprite").mModel:playAnimate(name, 0, animateEndHandler)
    co:pause("playAnimate")
end

return SOpeningCG