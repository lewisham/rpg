----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能输入目标选择
----------------------------------------------------------------------

local InputTargetSelector = class("InputTargetSelector")

function InputTargetSelector.create(skill)
    local ret = InputTargetSelector.new()
    ret.mSkill = skill
    return ret
end

function InputTargetSelector:ctor()
end

function InputTargetSelector:play(id, args)
    local func = self["solution"..id]
    local list = func(self, args)
    return list
end

-- 1敌方所有存活目标
function InputTargetSelector:solution1()
    local tb = g_ActionList:getActors()
    local caster = self.mSkill.mMonster
    local group = EnemyGroup(caster:findComponent("GroupID"))
	local list = {}
	for _, val in pairs(tb) do
		if val:findComponent("GroupID") == group and val:findComponent("HitPoint"):isAlive() then
			table.insert(list, val)
		end
	end
    return list
end

return InputTargetSelector
