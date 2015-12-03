----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：林惊雨技能
----------------------------------------------------------------------

local SXiaHouDun = class("SXiaHouDun", SKDisplay)

function SXiaHouDun:initDisplayRes()
	self:addSkillInfo(1, 0)
    self:addSkillInfo(2, 3)
    self:addSkillInfo(3, 3)
    self:addSkillInfo(4, 3)
end

-----------------------------
-- 技能1
-----------------------------
function SXiaHouDun:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    -- 判断攻击次数
    if self.mAttackTimes == 1 then
        self:playModelAnimate(model, "attack_1")
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForEvent(SK_EVENT.Movement_Complete, model)
    elseif self.mAttackTimes == 2 then
        self:playModelAnimate(model, "attack_2")
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step2")
        co:waitForEvent(SK_EVENT.Movement_Complete, model)
    else
        self:playModelAnimate(model, "attack_3")
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step2")
        co:waitForEvent(SK_EVENT.Frame_Event, model)
        logic:resume("step3")
        co:waitForEvent(SK_EVENT.Movement_Complete, model)
    end

    self:playBackOff()
	self:over()
end

function SXiaHouDun:excuteLogic1(co)
    self:calcTargets()
    self.mAttackTimes = math.random(1, 3)
    --self.mAttackTimes = 2
    for i = 1, self.mAttackTimes do
        co:pause("step"..i)
        self:makeDamage(1)
    end
    if self.mAttackTimes == 3 then
        self:playState(Monster_State.JiTui)
    end
end

-----------------------------
-- 技能2
-----------------------------
function SXiaHouDun:playDisplay2(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(7))
    co:waitForEvent(SK_EVENT.Move_Complete, monster)
    self:playMask()
    self:playModelAnimate(model, "skill")
    self:playEffectOnce("xiahoudun", "skill", self:getPos(6), false)
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    logic:resume("step2")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)
    self:playBackOff()
	self:over()
end

function SXiaHouDun:excuteLogic2(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
    co:pause("step2")
    self:makeDamage(1)
end

-----------------------------
-- 技能3
-----------------------------

function SXiaHouDun:initSkill3()
end

function SXiaHouDun:playDisplay3(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    self:playEffectOnce("shoujitexiao", "duang", self:getPos(3), false)
    co:waitForSeconds(0.15)
    self:playMask()
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    co:waitForEvent(SK_EVENT.Move_Complete, monster)
    self:playModelAnimate(model, "skillchase_1")
    self:playEffectOnce("xiahoudun", "skillchase_1", self:getPos(3), false)
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)
    self:playBackOff()
	self:over()
end

function SXiaHouDun:excuteLogic3(co)
    co:pause("step1")
    self.mTarget:findComponent("HitPoint"):bearDamage(self:calcDamage(1))
end

-----------------------------
-- 技能4分身
-----------------------------

function SXiaHouDun:playDisplay4(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    self:playEffectOnce("shoujitexiao", "duang", self:getPos(3), false)
    co:waitForSeconds(0.15)
    --self:playMask()
    -- 移动
    self:playModelAnimate(model, "skillchase_2")
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)
    self:playBackOff()
	self:over()
end

function SXiaHouDun:excuteLogic4(co)
    co:pause("step1")
    local list = createPhantasm(self.mMonster)
end

return SXiaHouDun
