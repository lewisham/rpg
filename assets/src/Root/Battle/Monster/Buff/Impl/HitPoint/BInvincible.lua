----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：无敌,免役所有伤害
----------------------------------------------------------------------

local BInvincible = class("BInvincible", BuffBase)

--初始化
function BInvincible:init(helper, config)
	BInvincible.super.init(self, helper, config)
	self:changeState("invincible", false)
	self:register(BATTLE_EVENT.Settle_Damage)
end

-- 解析筛选参数
function BInvincible:parseFilterParamter(msg)
	self.mFilterMonster = msg:get("monster")
end

-- 执行
function BInvincible:execute(msg)
	local dp = msg:get("dp")
	-- 只对伤害有效
	if dp > 0 then return end
	msg:set("dp", 0)
end

-- 清除buff
function BInvincible:onCleanup()
	self:changeState("invincible", true)
	BInvincible.super.onCleanup(self)
end

return BInvincible