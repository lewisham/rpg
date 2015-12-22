----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：林惊雨技能
----------------------------------------------------------------------

local SXiaHouDun = class("SXiaHouDun", SKDisplay)

SXiaHouDun.sound_file_list = {}
SXiaHouDun.sound_file_list[1] = "sound/weiyan_atk1.mp3"
SXiaHouDun.sound_file_list[2] = "sound/weiyan_atk2.mp3"
SXiaHouDun.sound_file_list[3] = "sound/weiyan_atk3.mp3"
SXiaHouDun.sound_file_list[4] = "sound/weiyan_cast.mp3"
SXiaHouDun.sound_file_list[5] = "sound/xiahoudun_skill.mp3"
SXiaHouDun.sound_file_list[6] = "sound/weiyan_def.mp3"

function SXiaHouDun:initDisplayRes()
	self:addSkillInfo(1, 0)
    self:addSkillInfo(2, 3)
    --self:addSkillInfo(3, 3)
    --self:addSkillInfo(4, 3)
end

-----------------------------
-- 技能1
-----------------------------
function SXiaHouDun:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    co:waitForDisplayEvent(SDISPLAY_EVENT.Move_Complete, monster)

    -- 判断攻击次数
    if self.mAttackTimes == 1 then
        self:playModelAnimate(model, "attack_1")
        self:playSound(1)
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    elseif self.mAttackTimes == 2 then
        self:playModelAnimate(model, "attack_2")
        self:playSound(1)
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        self:playSound(2)
        logic:resume("step2")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    else
        self:playModelAnimate(model, "attack_3")
        self:playSound(1)
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        self:playSound(2)
        logic:resume("step2")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        self:playSound(3)
        logic:resume("step3")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    end

    self:playBackOff()
	self:over()
end

function SXiaHouDun:excuteLogic1(co)
    self:calcTargets()
    self.mAttackTimes = PseudoRandom.random(1, 3)
    --self.mAttackTimes = 2
    for i = 1, self.mAttackTimes do
        co:pause("step"..i)
        self:makeDamage(1)
    end
    if self.mAttackTimes == 3 then
        --self:playState(Monster_State.JiTui)
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
    co:waitForDisplayEvent(SDISPLAY_EVENT.Move_Complete, monster)
    self:playMask()
    self:playModelAnimate(model, "skill")
    self:playSound(5)
    self:playEffectOnce("xiahoudun", "skill", self:getPos(6), false)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    logic:resume("step2")
    co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
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
    co:waitForDisplayEvent(SDISPLAY_EVENT.Move_Complete, monster)
    self:playModelAnimate(model, "skillchase_1")
    self:playEffectOnce("xiahoudun", "skillchase_1", self:getPos(3), false)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    self:playBackOff()
	self:over()
end

function SXiaHouDun:excuteLogic3(co)
    co:pause("step1")
    self.mTarget:findComponent("HitPoint"):modifyHitPoint(self:calcDamage(1))
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
    co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    self:playBackOff()
	self:over()
end

function SXiaHouDun:excuteLogic4(co)
    co:pause("step1")
    local list = createPhantasm(self.mMonster, 1)
end

return SXiaHouDun
