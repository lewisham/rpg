----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：动作编辑
----------------------------------------------------------------------

local SMonsterEdit = class("SMonsterEdit", GameScene)

-- 初始化
function SMonsterEdit:init(args)
    require "data.monster_config"
    require "data.monster_model"
    require "data.escort_config"
    self.config = escort_config[1001]
    InitBattleGlobal()
    StartCoroutine(self, "play")
    ENABLE_SOUND = true
end

-- 开始执行逻辑
function SMonsterEdit:play(co)
    local list1 = {20001, 20002}--{20002, 10001, 10004, 10002}
    local list2 = {20001, 20002}
    local list = {}
    local function addlist(tb)
        for _, id in pairs(tb) do table.insert(list, id) end
    end
    addlist(list1)
    addlist(list2)
    PseudoRandom.setRand(math.random(1, 10000))
    self:createGameObject("prefabs.ui.UILoading", list):play(co)
    self:removeGameObject("UILoading")
    cc.SimpleAudioEngine:getInstance():playMusic("sound/bgm_battle2.mp3", true)
    self:createGameObject("prefabs.ui.UIScene", "Scene/scene16/scene16_3.csb")--"Scene/scene07/scene07_1.csb"
    self:createGameObject("prefabs.skill.helper.SkillHelper")
    self:createGameObject("prefabs.round.Camp")

    self:findGameObject("UIScene"):cameraMoveTo(0, 0)
    --self:playLoopModel(20002)
    --self:playEffect("guanfeng", cc.p(512, 100))

    self:initMonster(list1, list2)
    WaitForFuncResult(co, function() return self:findGameObject("ActionList"):isBattleEnd() end)
    self:removeGameObject("ActionList")
    Player:getInstance():goHome()
end

function SMonsterEdit:initMonster(list1, list2)
    self:createGameObject("prefabs.round.ActionList")
    for key, id in ipairs(list1) do
        local monster = self:createMonster(id, CalcFormantionPos(key, 1), 1, key)
        self:findGameObject("ActionList"):addActor(monster)
    end

    for key, id in ipairs(list2) do
        local monster = self:createMonster(id, CalcFormantionPos(key, 2), 2, key)
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
    local ret = self:createGameObject("prefabs.monster.Monster", args)
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
    local effect = CreateSkillEffect(name, args)
    self:getRoot():addChild(effect)
    effect:loopPlay()
    effect:setPosition(pos)
end


return SMonsterEdit