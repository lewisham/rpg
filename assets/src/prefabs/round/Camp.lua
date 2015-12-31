----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：营地
----------------------------------------------------------------------

local Camp = class("Camp", GameObject)

function EnemyGroup(group)
    if group == 1 then
		group = 2
	else
		group = 1
	end
    return group
end

function Camp:init()
    self.mActors = {}
end

function Camp:addActor(actor)
    table.insert(self.mActors, actor)
end

-- 重新排序
function Camp:sortZOrder()
    for key, val in pairs(self.mActors) do
        val = val:getSelf()
        if val == nil then
            self.mActors[key] = nil
            break
        end
        local node = val:findComponent("ActionSprite")
        node:onOrder()
    end
end

-- 计算技能选取目标
function Camp:search(caster, iType)
	local group = EnemyGroup(caster:findComponent("GroupID"))
	local list = {}
	for _, val in pairs(self.mActors) do
		if val:findComponent("GroupID") == group then
			table.insert(list, val)
		end
	end
    return list
end


return Camp
