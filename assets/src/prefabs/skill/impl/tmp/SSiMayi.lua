----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：司马毅技能
----------------------------------------------------------------------

local SSiMayi = class("SSiMayi", SKDisplay)

-----------------------------
-- 技能1
-----------------------------
function SSiMayi:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "attack_1")
    self:playEffectOnce("simayi", "attack_1", self:getPos(3))
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    logic:resume("step1")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)

    -- 回退
    self:playBackOff()
end

function SSiMayi:excuteLogic1(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

-----------------------------
-- 技能4
-----------------------------
function SSiMayi:playDisplay4(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    self:playModelAnimate(model, "skill")

    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    self:playMask()
    self:playEffectOnce("shoujitexiao", "duang", self:getPos(3))

    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    self:StartCoroutine("targetEffect4", logic)

    WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)

    self:playBackOff()
end

function SSiMayi:targetEffect4(co, logic)
    self:playEffectOnce("simayi", "skill", self:getPos(6))
    WaitForSeconds(co, 1.6)
    logic:resume("step1")
    WaitForSeconds(co, 0.3)
    logic:resume("step2")
    WaitForSeconds(co, 0.3)
    logic:resume("step3")
end

function SSiMayi:excuteLogic4(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
    co:pause("step2")
    self:makeDamage(1)
    co:pause("step3")
    self:makeDamage(1)
end

return SSiMayi
