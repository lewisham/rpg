----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：魏延技能
----------------------------------------------------------------------

local SWeiYan = class("SWeiYan", SKDisplay)

SWeiYan.sound_file_list = {}
SWeiYan.sound_file_list[1] = "sound/weiyan_atk1.mp3"
SWeiYan.sound_file_list[2] = "sound/weiyan_atk2.mp3"
SWeiYan.sound_file_list[3] = "sound/weiyan_atk3.mp3"
SWeiYan.sound_file_list[4] = "sound/weiyan_cast.mp3"
SWeiYan.sound_file_list[5] = "sound/weiyan_skill.mp3"
SWeiYan.sound_file_list[6] = "sound/weiyan_def.mp3"

function SWeiYan:initDisplayRes()
    self:addSkillInfo(1, 0, false)
	self:addSkillInfo(2, 3, false)
    self:addSkillInfo(3, 0, true)
    self:addSkillInfo(4, 0, true)
end

-------------------------------------------------
-- 技能1：普通攻击，概率触发三连击，并击晕
-------------------------------------------------
function SWeiYan:playDisplay1(co, logic)
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
        self:playSound(1)
        self:playModelAnimate(model, "attack_2")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step2")
        self:playSound(1)
        co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    else
        self:playModelAnimate(model, "attack_3")
        self:playSound(1)
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step2")
        self:playSound(2)
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step3")
        co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    end

    self:playBackOff()
	self:over()
end

function SWeiYan:excuteLogic1(co)
    self:calcTargets(1)
    self.mAttackTimes = PseudoRandom.random(1, 3)
    for i = 1, self.mAttackTimes do
        co:pause("step"..i)
        self:makeDamage(1)
    end
end

-------------------------------------------------
-- 技能2：移动到敌方阵形中心，造成aoe伤害
-------------------------------------------------
function SWeiYan:playDisplay2(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(6))
    self:cameraFollowCaster(0.2)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Move_Complete, monster)
    self:playModelAnimate(model, "skill")
    self:playSound(4)
    for i = 1, 8 do
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
    end
    self:playSound(5)
    for i = 1, 5 do
        co:waitForDisplayEvent(SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step"..i)
    end
    self:playSound(1)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    self:cameraRecover()
    self:playBackOff()
	self:over()
end

function SWeiYan:excuteLogic2(co)
    self:calcTargets(2)
    for i = 1, 5 do
        co:pause("step"..i)
        self:makeDamage(1)
    end
end

-------------------------------------------------
-- 技能3：受到伤害时，一定几率免役，攻击时一定几率造成数倍伤害，但会损失自身一定生命值
-------------------------------------------------

function SWeiYan:initSkill3()
    SModifyHitPoint:getInstance():register(self.mMonster, function(...) self:onModifyHitPoint3(...) end)
end

function SWeiYan:onModifyHitPoint3(damage)
    if damage:getTarget() == self.mMonster then
        self:onBearDamage3(damage)
    elseif damage:getCaster() == self.mMonster then
        self:onMakeDamage3(damage)
    end
end

-- 受到伤害时
function SWeiYan:onBearDamage3(damage)
    local r = PseudoRandom.random(0, 100)
    local rate = 30
    if r > rate then return end
    damage:reset(0)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    self:playSound(6)
    self:playModelAnimateOnce(model, "cast")
end

-- 造成伤害时
function SWeiYan:onMakeDamage3(damage)
    if self.mPlayingIdx ~= 1 then return end
    local r = PseudoRandom.random(0, 100)
    local rate = 60
    if r > rate then return end
    self:playEffectOnce("shoujitexiao", "fireground_3", self:getPos(3), false, 3)
    local value = damage:getDamage()
    local amp = math.floor(value * 2.5)
    damage:addAmplify(amp)

    local dp = self:calcDamage(2, self.mMonster, 2)
    self.mMonster:findComponent("HitPoint"):modifyHitPoint(dp)
end

-------------------------------------------------
-- 技能4：回合开始时,一定几率恢复5%的生命值
-------------------------------------------------
function SWeiYan:initSkill4()
    local function condition(caster)
        local r = PseudoRandom.random(0, 100)
        local rate = 60
        if r > rate then return false end
        return caster == self.mMonster
    end
    local function handler(caster, co)
        self:onRoundStart4(co)
    end
    SRoundStart:getInstance():register(condition, handler, 1)
end

function SWeiYan:onRoundStart4(co)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    self:playEffectOnce("shoujitexiao", "blood_1", self:getPos(3), false)
    self:playModelAnimate(model, "cast")
    local dp = self:calcHealth(2, self.mMonster, 5)
    self.mMonster:findComponent("HitPoint"):modifyHitPoint(dp)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
end

return SWeiYan
