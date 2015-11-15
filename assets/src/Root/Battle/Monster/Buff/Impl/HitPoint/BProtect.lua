----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：护卫,伤害互换
----------------------------------------------------------------------

local BProtect = class("BProtect", BuffBase)

-- 构造
function BProtect:ctor()
	BProtect.super.ctor(self)
end

-- 初始化
function BProtect:init(helper, config)
	BProtect.super.init(self, helper, config)
	self:register(BATTLE_EVENT.Before_Settle_Damage, BATTLE_EVENT_PRIORITY_HIGHEST)
end

-- 解析筛选参数
function BProtect:parseFilterParamter(msg)
	self.mFilterMonster = msg:get("damage"):get("defender")
end

-- 被击事件
function BProtect:execute(msg)
	local damage = msg:get("damage")
	-- 只结算扣血伤害
	if damage:get("modify_target") ~= "hit_point" or damage:get("operate") ~= "-" then
		return
	end
	-- 把伤害转移到，施加这buff的人身上
	damage:set("defender", self:get("caster"))
end

return BProtect
