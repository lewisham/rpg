----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：buff 反击
----------------------------------------------------------------------

local BCounterAttack = class("BCounterAttack", BuffBase)

--构造
function BCounterAttack:ctor()
	BCounterAttack.super.ctor(self)
end

--初始化
function BCounterAttack:init(helper, config)
	BCounterAttack.super.init(self, helper, config)
	self:register(BATTLE_EVENT.Caster_Skill_Finish)
end

-- 解析筛选参数
function BCounterAttack:parseFilterParamter(msg)
	local defender = self.mBuffHelper.mMonster
	
	-- 不可操作时不可反击
	if not defender:getComponent("StateHelper"):isControllable() then
		return
	end
	
	if defender:getComponent("group") == msg:get("monster"):getComponent("group") then
		return
	end
	
	-- 自己是否被攻击
	local total = msg:get("record"):getTargetBearDamage(defender)
	-- 判断是否受到伤害
	if total <= 0 then
		return
	end
	self.mFilterMonster = defender
end

-- 执行
function BCounterAttack:execute(msg)
	self:getData("CounterAttackList"):add(self.mBuffHelper.mMonster)
	return true
end

return BCounterAttack
