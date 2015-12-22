----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：林惊雨技能
----------------------------------------------------------------------

local SLinYu = class("SLinYu", SKDisplay)

function SLinYu:initDisplayRes()
	self:addSkillInfo(1, 0)
end

-----------------------------
-- 技能1
-----------------------------
function SLinYu:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    co:waitForDisplayEvent(SDISPLAY_EVENT.Move_Complete, monster)

    -- 判断攻击次数
    self:playModelAnimate(model, "attack1_1")
    co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    logic:resume("step1")
    co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    self:playBackOff()
	self:over()
end

function SLinYu:excuteLogic1(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
end

return SLinYu
