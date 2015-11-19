----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：回合
----------------------------------------------------------------------

local Round = class("Round", Root)


function Round:init(actor)
    self.mActors = actor
    startCoroutine(self, "play")
end

function Round:play(co)
    self:input(co)
    self:beforeCast(co)
    self:casting(co)
    self:chaseListener(co)
end

-- 输入
function Round:input(co)
    local targets = Root:findRoot("Camp"):search(self.mActors, 1)
    local target = targets[math.random(1, #targets)]
    local skill = self.mActors:getChild("Skill1")
	require(skill.__path)
    local list = skill:getSkillInfo()
    local r = math.random(1, #list)
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
    self.mActors:getChild("Skill1"):play(self.mIdx, self.mTarget)
end

-- 追打监听
function Round:chaseListener(co)
end

return Round
