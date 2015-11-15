----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：持续恢复
----------------------------------------------------------------------

local BHot = class("BHot", BuffBase)

-- 构造
function BHot:ctor()
	BHot.super.ctor(self)
	self.mLifeDec = 0
end

-- 初始化
function BHot:init(helper, config)
	BHot.super.init(self, helper, config)
	local monster = helper.mMonster
	local hp = monster:getComponent("HitPoint"):getMax()
	local percentage = config.param
	self.mLifeDec = math.ceil(percentage / 100 * hp)
end


-- 自身逻辑
function BHot:logic(event)
	local list = event:get("hit_point_modify_list")
	table.insert(list, self.mLifeDec)
	event:operate("hit_point", self.mLifeDec)
end

return BHot