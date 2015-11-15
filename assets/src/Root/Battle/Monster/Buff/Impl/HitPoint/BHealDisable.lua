----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：治疗无效
----------------------------------------------------------------------

local BHealDisable = class("BHealDisable", BuffBase)

--初始化
function BHealDisable:init(helper, config)
	BHealDisable.super.init(self, helper, config)
	self:register(BATTLE_EVENT.Settle_Damage)
end

-- 解析筛选参数
function BHealDisable:parseFilterParamter(msg)
	self.mFilterMonster = msg:get("monster")
end

-- 执行
function BHealDisable:execute(msg)
	local dp = msg:get("dp")
	-- 只对治疗有效
	if dp < 0 then return false end
	msg:set("dp", 0)
	return true
end

-- 清除buff
function BHealDisable:onCleanup()
	BHealDisable.super.onCleanup(self)
end

return BHealDisable