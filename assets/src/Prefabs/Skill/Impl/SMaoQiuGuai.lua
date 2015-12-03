----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：毛球怪技能
----------------------------------------------------------------------

local SMaoQiuGuai = class("SMaoQiuGuai", SKDisplay)

function SMaoQiuGuai:initDisplayRes()
    self:addSkillInfo(1, 0)
end

-----------------------------
-- 技能1
-----------------------------
function SMaoQiuGuai:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "skill1_move", self:getPos(1), 0.2)
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skill1_attack")
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)
    self:playModelAnimate(model, "skill1_end")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)
    self:playBackOff("skill1_end", 0)
	self:over()
end

function SMaoQiuGuai:excuteLogic1(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

return SMaoQiuGuai
