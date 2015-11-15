----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：持续伤害
----------------------------------------------------------------------

local BDot = class("BDot", BuffBase)

-- 构造
function BDot:ctor()
	BDot.super.ctor(self)
	self.mLifeDec = 0
end

-- 初始化
function BDot:init(helper, config)
	BDot.super.init(self, helper, config)
	local monster = helper.mMonster
	local hitPoint = monster:getComponent("HitPoint")
	local percentage = config.param
	self.mLifeDec = -math.ceil(percentage / 100 * hitPoint:getMax())
end


-- 自身逻辑
function BDot:logic(event)
	local list = event:get("hit_point_modify_list")
	table.insert(list, self.mLifeDec)
	event:operate("hit_point", self.mLifeDec)
end

return BDot