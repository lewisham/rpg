----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：营地
----------------------------------------------------------------------

local Camp = class("Camp", Root)

function Camp:init()
    self.mActors = {}
end

function Camp:addActor(actor)
    table.insert(self.mActors, actor)
end

function Camp:search(caster, iType)
	local group = caster:getChild("GroupID")
	if group == 1 then
		group = 2
	else
		group = 1
	end
	local target = nil
	for _, val in pairs(self.mActors) do
		if val:getChild("GroupID") == group then
			target = val
			break
		end
	end

    return target
end


return Camp
