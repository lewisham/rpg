----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：野狼技能
----------------------------------------------------------------------

local SWildWolf = class("SWildWolf", SKDisplay)

function SWildWolf:initDisplayRes()
	self:addSkillInfo(1, 0)
    self:addSkillInfo(2, 0)
    self:addSkillInfo(3, 0)
end

-----------------------------
-- 技能1
-----------------------------
function SWildWolf:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "skill1_move", self:getPos(1), 0.3)
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skill1_attack")
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)

    self:playBackOff("skill1_end", 0.2)
	self:over()
end

function SWildWolf:excuteLogic1(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

-----------------------------
-- 技能2
-----------------------------
function SWildWolf:playDisplay2(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "skill2_move", self:getPos(1, 90), 0.3)
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skill2_attack")
    --co:waitForEvent(SK_EVENT.Frame_Event, model)
    co:waitForSeconds(0.5)
    logic:resume("step1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)

    self:playBackOff("skill2_end", 0.2)
	self:over()
end

function SWildWolf:excuteLogic2(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

-----------------------------
-- 技能3
-----------------------------
function SWildWolf:playDisplay3(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel

    self:playModelAnimate(model, "skill3_attack")
    --co:waitForEvent(SK_EVENT.Frame_Event, model)
    co:waitForSeconds(0.5)
    logic:resume("step1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)

    self:playBackOff("skill2_end", 0.2)
	self:over()
end

function SWildWolf:excuteLogic3(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

return SWildWolf
