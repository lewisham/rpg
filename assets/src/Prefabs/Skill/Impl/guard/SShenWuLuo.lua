----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：大将神武罗技能
----------------------------------------------------------------------

local SShenWuLuo = class("SShenWuLuo", SKDisplay)

SShenWuLuo.sound_file_list = {}
SShenWuLuo.sound_file_list[1] = "sound/shenwuluo_atk1.mp3"
SShenWuLuo.sound_file_list[2] = "sound/shenwuluo_atk2.mp3"
SShenWuLuo.sound_file_list[3] = "sound/shenwuluo_atk3.mp3"
SShenWuLuo.sound_file_list[4] = "sound/shenwuluo_cast.mp3"
SShenWuLuo.sound_file_list[5] = "sound/shenwuluo_skill.mp3"
SShenWuLuo.sound_file_list[6] = "sound/shenwuluo_def.mp3"

function SShenWuLuo:initDisplayRes()
    self.mAttackTimes = -1
    self:addSkillInfo(1, 0, false)
	self:addSkillInfo(2, 3, false)
    self:addSkillInfo(3, 0, true)
    self:addSkillInfo(4, 0, true)
end

-------------------------------------------------
-- 技能1：普通攻击，概率触发三连击，并击晕
-------------------------------------------------
function SShenWuLuo:playDisplay1(co, logic)
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

function SShenWuLuo:excuteLogic1(co)
    self:calcTargets(1)
    if self.mAttackTimes == -1 then
        self.mAttackTimes = PseudoRandom.random(1, 3)
    end
    for i = 1, self.mAttackTimes do
        co:pause("step"..i)
        self:makeDamage(1)
    end
    self.mAttackTimes = -1
end

-------------------------------------------------
-- 技能2：移动到敌方阵形中心，造成aoe伤害
-------------------------------------------------
function SShenWuLuo:playDisplay2(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel

    self:playEffectOnce("shoujitexiao", "duang", self:getPos(3), false)
    co:waitForSeconds(0.45)
    self:playMask()

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

function SShenWuLuo:excuteLogic2(co)
    self:calcTargets(2)
    for i = 1, 5 do
        co:pause("step"..i)
        self:makeDamage(1)
    end
end

-------------------------------------------------
-- 技能3：受到伤害时，一定几率免役，攻击时一定几率造成数倍伤害，但会损失自身一定生命值
-------------------------------------------------

function SShenWuLuo:initSkill3()
    SModifyHitPoint:getInstance():register(self.mMonster, function(...) self:onModifyHitPoint3(...) end)
end

function SShenWuLuo:onModifyHitPoint3(damage)
    if damage:getTarget() == self.mMonster then
        self:onBearDamage3(damage)
    elseif damage:getCaster() == self.mMonster then
        self:onMakeDamage3(damage)
    end
end

-- 受到伤害时
function SShenWuLuo:onBearDamage3(damage)
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
function SShenWuLuo:onMakeDamage3(damage)
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
-- 技能4：回合开始时,一定几率恢复5%的生命值,如普通攻击触发时,必定触发三连击
-------------------------------------------------
function SShenWuLuo:initSkill4()
    self:initAura4_1()
end

function SShenWuLuo:initAura4_1()
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

function SShenWuLuo:onRoundStart4(co)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    self:playEffectOnce("shoujitexiao", "blood_1", self:getPos(3), false)
    self:playModelAnimate(model, "cast")
    local dp = self:calcHealth(2, self.mMonster, 5)
    self.mMonster:findComponent("HitPoint"):modifyHitPoint(dp)
    co:waitForDisplayEvent(SDISPLAY_EVENT.Movement_Complete, model)
    -- 三连击
    if self.mPlayingIdx == 1 then self.mAttackTimes = 3 end
end

return SShenWuLuo
