----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：流风云技能
----------------------------------------------------------------------

local SLiuFengYun = class("SLiuFengYun", SKDisplay)

SLiuFengYun.sound_file_list = {}

function SLiuFengYun:initDisplayRes()
	self:addSkillInfo(1, 0)
    self:addSkillInfo(2, 3)
end

-----------------------------
-- 技能1
-----------------------------
function SLiuFengYun:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1, 150))
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Move_Complete, monster)

    -- 判断攻击次数
    if self.mAttackTimes == 1 then
        self:playModelAnimate(model, "attack_1")
        self:playEffectOnce("Zhujiao_feng_effect", "attack_1", self:getPos(3), false)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    elseif self.mAttackTimes == 2 then
        self:playModelAnimate(model, "attack_2")
        self:playEffectOnce("Zhujiao_feng_effect", "attack_2", self:getPos(3), false)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step2")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    else
        self:playModelAnimate(model, "attack_3")
        self:playEffectOnce("Zhujiao_feng_effect", "attack_3", self:getPos(3), false)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step2")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step3")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    end

    self:playBackOff()
	self:over()
end

function SLiuFengYun:excuteLogic1(co)
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
function SLiuFengYun:playDisplay2(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skill1")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    logic:resume("step1")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    self:playBackOff()
	self:over()
end

function SLiuFengYun:excuteLogic2(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

-----------------------------
-- 技能3
-----------------------------
function SLiuFengYun:playDisplay3(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "attack1_1")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    self:playEffectOnce("Zhujiao_feng_effect", "attack1_1", self:getPos(3))
    print("play effect", "attack1_1")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    self:playBackOff()
end

function SLiuFengYun:excuteLogic3(co)
end

-----------------------------
-- 技能4
-----------------------------
function SLiuFengYun:playDisplay4(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skill1")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    self:playMask()
    self:playEffectOnce("shoujitexiao", "duang", self:getPos(3))
    self:playEffectOnce("Zhujiao_feng_effect", "Skill1", self:getPos(3))
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    self:playBackOff()
end

function SLiuFengYun:excuteLogic4(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
    co:pause("step2")
    self:makeDamage(1)
    co:pause("step3")
    self:makeDamage(1)
end

return SLiuFengYun
