----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能表现接口
----------------------------------------------------------------------

SKDisplay = class("SKDisplay", SKLogic)

SKDisplay.sound_file_list = {}

-- 初始化表现
function SKDisplay:initDisplay()
    self:createSelector("PositionSelect")
end

-- 获得位置
function SKDisplay:getPos(id, args)
    return self.PositionSelect:play(id, args)
end

-- 提高施法者的层级
function SKDisplay:changeZOrder(val)
    val = val or 0
    self.mMonster:findComponent("ActionSprite"):setExtraZOrder(val)
end

-- 回退
function SKDisplay:playBackOff(name, duration)
    local monster = self.mMonster
    local pos1 = self:getPos(2)
    local pos2 = self:getPos(3)
    name = name or "moveback"
    duration = duration or 0.075
    if math.abs(pos1.x - pos2.x) > 2 or math.abs(pos1.y - pos2.y) > 2 then
        self:playMonsterMove(monster, name, self:getPos(2), duration)
        WaitForDisplayEvent(self.mDisplayCO, SDISPLAY_EVENT.Move_Complete, monster)
    end
    self:changeZOrder(0)
    monster:findComponent("ActionSprite"):changeState("idle")
end

-----------------------------------------
-- 表现接口
-----------------------------------------

-- 播放怪物移动
function SKDisplay:playMonsterMove(monster, name, pos, duration)
    duration = duration or 0.1
    local function callback()
        self:changeZOrder(10)
        SDisplayEvent.post(SDISPLAY_EVENT.Move_Complete, monster)
    end
     local tb = 
    {
        cc.MoveTo:create(duration, pos),
        cc.CallFunc:create(callback, {}),
    }
    local node = monster:findComponent("ActionSprite")
    node:runAction(cc.Sequence:create(tb))
    local model = monster:findComponent("ActionSprite").mModel
    model:playAnimate(name, 1)
end

-- 播放模型动画
function SKDisplay:playModelAnimate(model, name)
    -- 动作完毕回调
    local function animateEndHandler()
        SDisplayEvent.post(SDISPLAY_EVENT.Movement_Complete, model)
    end

    -- 帧事件回调
    local function frameEventHandler(evt)
        SDisplayEvent.post(SDISPLAY_EVENT.Frame_Event, model, evt)
        if ENABLE_MODEL_EVT then
            print("frame evt", evt)
        end
    end
    model:playAnimate(name, 0, animateEndHandler, frameEventHandler)
end

function SKDisplay:playModelAnimateOnce(model, name)
    -- 动作完毕回调
    local function animateEndHandler()
        model:playAnimate("idle", 1)
    end
    model:playAnimate(name, 0, animateEndHandler)
end

-- 播放特效
function SKDisplay:playEffectOnce(file, name, pos, bReverse, zOrder)
    local root = zOrder == nil and g_FrontEffectRoot or g_BackEffectRoot
    local effect = CreateSkillEffect(file, args)
    root:addChild(effect)
    effect:setPosition(pos)
    local group = self.mMonster:findComponent("GroupID")
    if bReverse then
        group = EnemyGroup(group)
    end
    effect:initDirection(group)

    -- 帧事件回调
    local function frameEventHandler(evt)
        SDisplayEvent.post(SDISPLAY_EVENT.Frame_Event, effect, evt)
        --print(evt)
    end

    local function animateEndHandler()
        SDisplayEvent.post(SDISPLAY_EVENT.Movement_Complete, effect)
        effect:removeFromParent(true)
    end
    effect:playAnimate(name, 0, animateEndHandler, frameEventHandler)
    return effect
end

-- 播放遮罩
function SKDisplay:playMask()
    local cls = require("prefabs.skill.helper.effect.EMask")
    local list = {}
    table.insert(list, self.mMonster)
    for _, val in pairs(self.mTargetList) do
        table.insert(list, val)
    end
    local ret = cls.create({monsters = list})
    return ret
end

-- 改变角色状态
function SKDisplay:changeMonsterState(monster, name, args)
    local model = self.mTarget:findComponent("ActionSprite").mModel
    model:onHit()
end

function SKDisplay:cameraFollowCaster(duration)
    duration = duration or 0.1
    local dir = self.mMonster:findComponent("GroupID") == 1 and 1 or -1
    g_UIScene:cameraMoveTo(dir, duration)
end

function SKDisplay:cameraRecover()
    g_UIScene:cameraMoveTo(0, 0.1)
end

function SKDisplay:playSound(id)
    if not ENABLE_SOUND then return end
    local filename = self.sound_file_list[id]
    if filename == nil then return end
    cc.SimpleAudioEngine:getInstance():playEffect(filename)
end
