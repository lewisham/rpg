----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：宠德技能
----------------------------------------------------------------------

local SLinJingYu = class("SLinJingYu", SKDisplay)

function SLinJingYu:initDisplayRes()
	self:addSkillInfo(1, 0)
    self:addSkillInfo(2, 3)
end

-----------------------------
-- 技能1
-----------------------------
function SLinJingYu:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1), 0.15)
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "attack_3")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)
    self:playBackOff()
	self:over()
end

function SLinJingYu:excuteLogic1(co)
end

-----------------------------
-- 技能2
-----------------------------
function SLinJingYu:playDisplay2(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1), 0.15)
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skill1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)
    self:playBackOff()
	self:over()
end

function SLinJingYu:excuteLogic2(co)
end

-----------------------------
-- 技能3
-----------------------------
function SLinJingYu:playDisplay3(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1), 0.15)
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "attack1_1")
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    self:playEffectOnce("Zhujiao_feng_effect", "attack1_1", self:getPos(3))
    print("play effect", "attack1_1")
    co:waitForEvent(SK_EVENT.Movement_Complete, model)
    self:playBackOff()
end

function SLinJingYu:excuteLogic3(co)
end

-----------------------------
-- 技能4
-----------------------------
function SLinJingYu:playDisplay4(co, logic)
    local monster = self.mMonster
    local model = monster:getChild("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1), 0.15)
    co:waitForEvent(SK_EVENT.Move_Complete, monster)

    self:playModelAnimate(model, "skill1")
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    self:playMask()
    self:playEffectOnce("shoujitexiao", "duang", self:getPos(3))
    self:playEffectOnce("Zhujiao_feng_effect", "skill1", self:getPos(3))
    co:waitForEvent(SK_EVENT.Frame_Event, model)
    co:waitForEvent(SK_EVENT.Movement_Complete, model)
    self:playBackOff()
end

function SLinJingYu:excuteLogic4(co)
    self:calcTargets()
    co:pause("step1")
    self:makeDamage(1)
    co:pause("step2")
    self:makeDamage(1)
    co:pause("step3")
    self:makeDamage(1)
end

return SLinJingYu
