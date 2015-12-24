----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：角色类
----------------------------------------------------------------------

local SMonsterEdit = class("SMonsterEdit", GameScene)

SMonsterEdit.ROOT_PATH = "Root.Mode.SMonsterEdit"


-- 初始化
function SMonsterEdit:init(args)
    require "Prefabs.Skill.SKDefine"
    require "Data.monster_config"
    require "Data.monster_model"
    require "Data.escort_config"
    self.config = escort_config[1001]
    startCoroutine(self, "play")

    ENABLE_SOUND = true
end

-- 开始执行逻辑
function SMonsterEdit:play(co)
    local list1 = {10001, 10004}
    local list2 = {20001, 20002}
    local list = {}
    local function addlist(tb)
        for _, id in pairs(tb) do table.insert(list, id) end
    end
    addlist(list1)
    addlist(list2)
    PseudoRandom.setRand(200)
    self:createGameObject("Prefabs.UI.UILoading", list):play(co)
    self:removeGameObject("UILoading")

    cc.SimpleAudioEngine:getInstance():playMusic("sound/bgm_battle2.mp3", true)

    self:createGameObject("Prefabs.Skill.Skill")
    self:createGameObject("Prefabs.Round.Camp")
    self:createGameObject("Prefabs.UI.UIScene", self.config.scene_name)
    self:createGameObject("Prefabs.Skill.Effect.EffectRootMgr")

    self:findGameObject("UIScene"):cameraMoveTo(0, 0)
    --self:playLoopModel(20002)
    --self:playEffect("shoujitexiao", cc.p(512, 100))

    self:initMonster(list1, list2)
    co:waitForFuncResult(function() return self:findGameObject("ActionList"):isBattleEnd() end)
    self:removeGameObject("ActionList")
    Player:getInstance():goHome()
end

function SMonsterEdit:initMonster(list1, list2)
    self:createGameObject("Prefabs.Round.ActionList")
    for key, id in ipairs(list1) do
        local monster = self:createMonster(id, calcFormantionPos(key, 1), 1, key)
        self:findGameObject("ActionList"):addActor(monster)
    end

    for key, id in ipairs(list2) do
        local monster = self:createMonster(id, calcFormantionPos(key, 2), 2, key)
        self:findGameObject("ActionList"):addActor(monster)
    end
end

-- 创建怪物
function SMonsterEdit:createMonster(id, pos, group, fidx)
    local config = monster_config[id]
    local tb = clone(config)
    tb.model = clone(monster_model[tb.model_id])
    tb.hit_point = 1000
    tb.atk = 35
    local args = {config = tb, position = pos, group = group, fidx = fidx}
    local ret = self:createGameObject("Prefabs.Monster.Monster", args)
    self:findGameObject("Camp"):addActor(ret)
    return ret
end

function SMonsterEdit:playLoopModel(id)
    local tb = {}
    tb.idx = 0
    local monster = self:createMonster(id, cc.p(512, 300), 0)
    local function touchEvent(sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        --monster:findComponent("MState"):play(Monster_State.JiTui)
        monster:findComponent("ActionSprite").mModel:loopPlay(tb)
    end    
    local button = ccui.Button:create()
    button:setTouchEnabled(true)
    button:loadTextures("test_1.png", "test_1.png", "")
    button:setPosition(cc.p(512 - 150 + 100 * (5 - 1), 60))        
    button:addTouchEventListener(touchEvent)
    self:getRoot():addChild(button)
end

function SMonsterEdit:playEffect(name, pos)
    local effect = require("Prefabs.Skill.Effect.Effect").create(name, args)
    self:getRoot():addChild(effect)
    effect:loopPlay()
    effect:setPosition(pos)
end


return SMonsterEdit