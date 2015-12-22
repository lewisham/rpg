----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能目标选择
----------------------------------------------------------------------

local TargetSelect = class("TargetSelect")

function TargetSelect.create(skill)
    local ret = TargetSelect.new()
    ret.mSkill = skill
    return ret
end

function TargetSelect:play(id, args)
    local func = self["solution"..id]
    local tb = func(self, args)
    return tb
end

-- 1指定目标
function TargetSelect:solution1()
    return {self.mSkill.mTarget}
end

-- 2敌方所有存活
function TargetSelect:solution2()
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

return TargetSelect
