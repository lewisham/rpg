----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：大将风无痕技能(待完成)
----------------------------------------------------------------------

local SFengWuHen = class("SFengWuHen", SKDisplay)

SFengWuHen.sound_file_list = {}
SFengWuHen.sound_file_list[1] = "sound/fengwuhen_atk1.mp3"
SFengWuHen.sound_file_list[2] = "sound/fengwuhen_atk2.mp3"
SFengWuHen.sound_file_list[3] = "sound/fengwuhen_atk3.mp3"
SFengWuHen.sound_file_list[4] = "sound/fengwuhen_skill.mp3"

function SFengWuHen:initDisplayRes()
    self.mAttackTimes = -1
    self:addSkillInfo(1, 0, false)
    self:addSkillInfo(2, 1, false)
    self:addSkillInfo(3, 0, true)
    self:addSkillInfo(4, 0, true)
end

-------------------------------------------------
-- 技能1：普通攻击，概率触发三连击，并击晕
-------------------------------------------------
function SFengWuHen:playDisplay1(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel
    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Move_Complete, monster)
    -- 判断攻击次数
    if self.mAttackTimes == 1 then
        self:playModelAnimate(model, "attack_1")
        self:playSound(1)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    elseif self.mAttackTimes == 2 then
        self:playSound(1)
        self:playModelAnimate(model, "attack_2")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step2")
        self:playSound(1)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    else
        self:playModelAnimate(model, "attack_3")
        self:playEffectOnce("guanfeng", "attack_3", self:getPos(3), false)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        self:playSound(1)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step1")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step2")
        self:playSound(2)
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step3")
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    end

    self:playBackOff()
	self:over()
end

function SFengWuHen:excuteLogic1(co)
    self:calcTargets(1)
    self.mAttackTimes = PseudoRandom.random(1, 3)
    --self.mAttackTimes = 3
    for i = 1, self.mAttackTimes do
        co:pause("step"..i)
        self:makeDamage(1)
    end
end

-------------------------------------------------
-- 技能2：合击，攻击敌方单一单位，如果队友有神武罗时，自动触发神武罗1技能攻击目标
-------------------------------------------------
function SFengWuHen:playDisplay2(co, logic)
    local monster = self.mMonster
    local model = monster:findComponent("ActionSprite").mModel

    -- 移动
    self:playMonsterMove(monster, "front", self:getPos(1))
    self:cameraFollowCaster(0.2)
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Move_Complete, monster)
    self:playModelAnimate(model, "skill")
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
    self:playEffectOnce("guanfeng", "skill", self:getPos(3), false)

    self:playSound(1)
    for i = 1, 3 do
        WaitForDisplayEvent(co, SDISPLAY_EVENT.Frame_Event, model)
        logic:resume("step"..i)
    end
    self:playSound(1)
    WaitForDisplayEvent(co, SDISPLAY_EVENT.Movement_Complete, model)
    self:cameraRecover()
    self:playBackOff()
	self:over()
end

function SFengWuHen:excuteLogic2(co)
    self:beforCast2()
    self:calcTargets(1)
    for i = 1, 5 do
        co:pause("step"..i)
        self:makeDamage(1)
    end
end

function SFengWuHen:beforCast2()
    local ally = self.TargetSelect:play(101, "大将神武罗")[1]
    if not ally then return end
    StartCoroutine(self, "onBeforCast2", ally)
end

function SFengWuHen:onBeforCast2(co, ally)
    self.mRunningCount = self.mRunningCount + 1
    WaitForSeconds(co, 0.5)
    ally:findComponent("Skill1"):willPlay(1, self.mTarget)
    ally:findComponent("Skill1"):play(co, 1, self.mTarget)
    self:over()
end

-------------------------------------------------
-- 技能3：折射，减免22%的伤害，并把伤害折射给敌方所有单位
-------------------------------------------------

function SFengWuHen:initSkill3()
    SModifyHitPoint:getInstance():register(self.mMonster, function(...) self:onModifyHitPoint3(...) end)
end

function SFengWuHen:onModifyHitPoint3(damage)
    if damage:getTarget() ~= self.mMonster then
        return
    end
    local value = math.abs(damage:getDamage())
    local amp = math.floor(value * 0.22)
    damage:addAmplify(amp)

    local list = self.TargetSelect:play(2)
    for _, val in pairs(list) do
        local dp = CreateDamage(self.mMonster, val)
        dp:reset(-amp)
        val:findComponent("HitPoint"):modifyHitPoint(dp)
    end
end


-------------------------------------------------
-- 技能4：荒芜，敌方单位越少，造成的伤害越高，我方单位越多，受到的伤害越少
-------------------------------------------------

function SFengWuHen:initSkill4()
    SModifyHitPoint:getInstance():register(self.mMonster, function(...) self:onModifyHitPoint4(...) end)
end

function SFengWuHen:onModifyHitPoint4(damage)
    if damage:getTarget() == self.mMonster then
        self:onBearDamage4(damage)
    elseif damage:getCaster() == self.mMonster then
        self:onMakeDamage4(damage)
    end
end

-- 受到伤害时
function SFengWuHen:onBearDamage4(damage)
    local group = self.mMonster:findComponent("GroupID")
    local cnt = g_ActionList:calcCnt(function(val) 
        if val:findComponent("HitPoint"):isAlive() and val:findComponent("GroupID") == group then
            return true
        end
        return false
    end)
    if cnt < 2 then return end
    local value = math.abs(damage:getDamage())
    local red = math.floor((cnt - 1) * 0.15 * value)
    damage:addAmplify(red)
end

-- 造成伤害时
function SFengWuHen:onMakeDamage4(damage)
    local group = self.mMonster:findComponent("GroupID")
    local cnt = g_ActionList:calcCnt(function(val) 
        if val:findComponent("GroupID") ~= group then
            return not val:findComponent("HitPoint"):isAlive()
        end
        return false
    end)
    if cnt < 1 then return end
    local value = math.abs(damage:getDamage())
    local red = math.floor(cnt * 0.15 * value)
    damage:addAmplify(-red)
end



return SFengWuHen
