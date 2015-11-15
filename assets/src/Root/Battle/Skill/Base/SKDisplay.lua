----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能表现接口
----------------------------------------------------------------------

local SKDisplay = class("SKDisplay", SKLogic)
_G["SKDisplay"] = SKDisplay

-- 初始化表现
function SKDisplay:initDisplay()
    self.PositionSelect = require("Root.Battle.Skill.Selector.PositionSelect").create(self)
end

-- 获得位置
function SKDisplay:getPos(id, args)
    return self.PositionSelect:play(id, args)
end

-- 回退
function SKDisplay:playBackOff()
    local monster = self.mMonster
    local pos1 = self:getPos(2)
    local pos2 = self:getPos(3)
    if math.abs(pos1.x - pos2.x) > 2 or math.abs(pos1.y - pos2.y) > 2 then
        self:playMonsterMove(monster, "moveback", self:getPos(2), 0.1)
        self.mDisplayCO:waitForEvent(SK_EVENT.Move_Complete, monster)
    end
    monster:getChild("ActionSprite"):changeState("idle")
end

-----------------------------------------
-- 表现接口
-----------------------------------------

-- 播放怪物移动
function SKDisplay:playMonsterMove(monster, name, pos, duration)
    local function callback()
        SKEvent.post(SK_EVENT.Move_Complete, monster)
    end
    local node = monster:getChild("ActionSprite")
    node:actionMoveTo(pos, duration, callback)
    local model = monster:getChild("ActionSprite").mModel
    model:playAnimate(name, 1)
end

-- 播放模型动画
function SKDisplay:playModelAnimate(model, name)
    -- 动作完毕回调
    local function animateEndHandler()
        SKEvent.post(SK_EVENT.Movement_Complete, model)
    end

    -- 帧事件回调
    local function frameEventHandler(evt)
        SKEvent.post(SK_EVENT.Frame_Event, model, evt)
        --print(evt)
    end
    model:playAnimate(name, 0, animateEndHandler, frameEventHandler)
end

-- 播放特效
function SKDisplay:playEffectOnce(file, name, pos, zOrder)
    local root = zOrder == nil and g_FrontEffectRoot or g_BackEffectRoot
    local effect = require("Root.Battle.Skill.Effect.Effect").create(file, args)
    root:addChild(effect)
    effect:setPosition(pos)

    local function animateEndHandler()
        SKEvent.post(SK_EVENT.Movement_Complete, effect)
        effect:removeFromParent(true)
    end
    effect:playAnimate(name, 0, animateEndHandler, frameEventHandler)
    return effect
end

-- 播放遮罩
function SKDisplay:playMask()
    local cls = require("Root.Battle.Skill.Effect.EMask")
    local ret = cls.create({monsters = {self.mMonster, self.mTarget}})
    return ret
end

-- 改变角色状态
function SKDisplay:changeMonsterState(monster, name, args)
    local model = self.mTarget:getChild("ActionSprite").mModel
    model:onHit()
end

return SKDisplay
