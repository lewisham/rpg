----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：回合
----------------------------------------------------------------------

local Round = class("Round", Root)

function Round:init(actor)
    self.mActors = actor
    startCoroutine(self, "update")
end

function Round:update(co)
    local targets = Root:findRoot("Camp"):search(self.mActors, 1)
    local target = targets[math.random(1, #targets)]
    local skill = self.mActors:getChild("Skill1")
	require(skill.__path)
    local list = skill:getSkillInfo()
    local r = math.random(1, #list)
    local idx = list[r].id
    skill:play(idx, target)
end

return Round
