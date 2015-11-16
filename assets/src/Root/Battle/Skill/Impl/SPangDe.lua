----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：宠德技能
----------------------------------------------------------------------

local SPangDe = class("SPangDe", SKDisplay)

function SPangDe:initDisplayRes()
    self:addSkillInfo(1, 0)
    self:addSkillInfo(2, 3)
end

-----------------------------
-- 技能1普通攻击(几率3连击)造成小浮空
-----------------------------

function SPangDe:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    co:waitForEvent(SK_EVENT.Move_Complete, monster)
  
    -- 判断攻击次数
    if self.mAttackTimes == 1 then
        self:playModelAnimate(model, "attack_1")
        self:playEffectOnce("pangde", "attack_1", self:getPos(3), false)
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForEvent(SK_EVENT.Movement_Complete, model)
    elseif self.mAttackTimes == 2 then
        self:playModelAnimate(model, "attack_2")
        self:playEffectOnce("pangde", "attack_1", self:getPos(3), false)
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step1")
        self:playEffectOnce("pangde", "attack_2", self:getPos(3), false)
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step2")
        co:waitForEvent(SK_EVENT.Movement_Complete, model)
    else
        self:playModelAnimate(model, "attack_3")
        self:playEffectOnce("pangde", "attack_3_1", self:getPos(3), false)
        self:playEffectOnce("pangde", "attack_3_2", self:getPos(3), false, -1)
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step2")
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step3")
        co:waitForEvent(SK_EVENT.Movement_Complete, model)
    end

    -- 回退
    self:playBackOff()
    self:over()
end

function SPangDe:excuteLogic1(co)
    self:calcTargets()
    self.mAttackTimes = math.random(1, 3)
    --self.mAttackTimes = 2
    for i = 1, self.mAttackTimes do
        co:pause("step"..i)
        self:makeDamage(1)
    end
end

-----------------------------
-- 技能2
-----------------------------
function SPangDe:playDisplay2(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playMask()
    --self:playEffectOnce("shoujitexiao", "duang", self:getPos(3), false)
    self:playModelAnimate(model, "skill")
    self:playEffectOnce("pangde", "effect_2", self:getPos(3), false)
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)

    -- 回退
    self:playBackOff()
    self:over()
end

-- 执行技能1逻辑
function SPangDe:excuteLogic2(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

-----------------------------
-- 技能3
-----------------------------

function SPangDe:initSkill3()
    -- 注册被动触发事件

end

function SPangDe:playDisplay3(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skillchase_1")
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)

    -- 回退
    self:playBackOff()
    self:over()
end

-- 执行技能1逻辑
function SPangDe:excuteLogic3(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

return SPangDe
