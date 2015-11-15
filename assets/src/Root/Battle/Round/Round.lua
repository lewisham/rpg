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
    local target = Root:findRoot("Camp"):search(self.mActors, 1)
    local skill = self.mActors:getChild("Skill1")
	require(skill.__path)
    local list = skill:getSkillInfo()
    local r = math.random(1, #list)
    local idx = list[r].id
	idx = 2
    skill:play(idx, target)
end

return Round
