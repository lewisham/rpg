----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：不死
----------------------------------------------------------------------

local BImmortal = class("BImmortal", BuffBase)

--初始化
function BImmortal:init(helper, config)
	BImmortal.super.init(self, helper, config)
	self:register(BATTLE_EVENT.Settle_Damage)
end

-- 解析筛选参数
function BImmortal:parseFilterParamter(msg)
	self.mFilterMonster = msg:get("monster")
end

-- 执行
function BImmortal:execute(msg)
	-- 只对伤害有效
	local dp = msg:get("dp")
	if dp > 0 then return end
	local monster = self.mBuffHelper.mMonster
	local hp = monster:getComponent("HitPoint"):getCurrent()
	--lewisPrint("buff immortal effect", hp, dp)
	if hp <= math.abs(dp) then
		dp = hp - 1
		--把伤害值修改成
		msg:set("dp", -dp)
	end
end

-- 清除buff
function BImmortal:onCleanup()
	BImmortal.super.onCleanup(self)
end

return BImmortal