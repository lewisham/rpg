----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：回合
----------------------------------------------------------------------

local Round = class("Round", GameObject)


function Round:init(actor)
    self.mActors = actor
    StartCoroutine(self, "play")
end

function Round:play(co)
    self:input(co)
    self:beforeCast(co)
    self:casting(co)
    self:chaseListener(co)
    g_ActionList:iActorDone()
end

-- 输入
function Round:input(co)
    local skill = self.mActors:findComponent("Skill1")
    local targets = skill:getInputTargets()
    local target = targets[PseudoRandom.random(1, #targets)]
	require(skill.__path)
    local list = skill:getSkillInfo()
    local r = PseudoRandom.random(1, #list)
    local idx = list[r].id
    --co:waitForRoundInput()

    self.mTarget = target
    self.mIdx = idx
end

-- 前摇
function Round:beforeCast(co)
end

-- 施法中
function Round:casting(co)
    self.mActors:findComponent("Skill1"):willPlay(self.mIdx, self.mTarget)
    SRoundStart:getInstance():post(self.mActors, co)
    self.mActors:findComponent("Skill1"):play(co)
end

-- 追打监听
function Round:chaseListener(co)
end

return Round
