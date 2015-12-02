----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：姜维技能
----------------------------------------------------------------------

local SJiangWei = class("SJiangWei", SKDisplay)

-----------------------------
-- 技能1
-----------------------------
function SJiangWei:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:getComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    logic:resume("step1")

    -- 回退
    self:playBackOff()
end

function SJiangWei:excuteLogic1(co)
    co:pause("step1")
    self.mTarget:getComponent("HitPoint"):bearDamage(self:calcDamage(1))
end

-----------------------------
-- 技能2
-----------------------------
function SJiangWei:playDisplay2(co)
    local monster = self.mMonster
end


function SJiangWei:excuteLogic2(co)
end

-----------------------------
-- 技能3
-----------------------------
function SJiangWei:playDisplay3(co)
    local monster = self.mMonster
end

function SJiangWei:excuteLogic3(co)
end

-----------------------------
-- 技能4
-----------------------------
function SJiangWei:playDisplay4(co)
    local monster = self.mMonster
    local model = monster:getComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playMask()
    self:playEffectOnce("shoujitexiao", "duang", self:getPos(3))
    self:playModelAnimate(model, "skill")

    co:waitForEvent(SK_EVENT.Frame_Event, model)
    self:playEffectOnce("jiangwei", "attack_1", self:getPos(3))

    co:waitForEvent(SK_EVENT.Movement_Complete, model)

    self:playBackOff()
end

function SJiangWei:excuteLogic4(co)
end

return SJiangWei

