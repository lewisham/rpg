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
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "skill1_move", self:getPos(1), 0.3)
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skill1_attack")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    logic:resume("step1")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)

    self:playBackOff("skill1_end", 0.4)
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
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "skill2_move", self:getPos(1, 90), 0.3)
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skill2_attack")
    --WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    WaitForSeconds(co, 0.5)
    logic:resume("step1")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)

    self:playBackOff("skill2_end", 0.4)
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
    local model = monster:findComponent("ActionSprite").mModel

    self:playModelAnimate(model, "skill3_attack")
    --WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    WaitForSeconds(co, 0.5)
    logic:resume("step1")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)

    self:playBackOff("skill2_end", 0.4)
	self:over()
end

function SWildWolf:excuteLogic3(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

return SWildWolf
