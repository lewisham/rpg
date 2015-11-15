----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：伤害反弹
----------------------------------------------------------------------

local BReflect = class("BReflect", BuffBase)

--构造
function BReflect:ctor()
	BReflect.super.ctor(self)
	self.mPercentage = 30		--反弹伤害比率
end

--初始化
function BReflect:init(helper, config)
	BReflect.super.init(self, helper, config)
	self:register(BATTLE_EVENT.After_Settle_Damage)
end

-- 条件判断
function BReflect:conditionJudge(msg)
	local damage = msg:get("damage")
	--只结算扣血伤害
	if damage:get("modify_target") ~= "hit_point" or damage:get("operate") ~= "+" then
		return false
	end
	return true
end

-- 解析筛选参数
function BReflect:parseFilterParamter(msg)
	if not self:conditionJudge(msg) then
		return
	end
	self.mFilterMonster = msg:get("damage"):get("defender")
end

-- 执行
function BReflect:execute(msg)
	local damage = msg:get("damage")
	
	-- 计算反弹伤害量
	local dp = math.ceil(self.mPercentage / 100 * damage:get("value"))
	local reflect = Damage.new()
	reflect:set("attacker", damage:get("defender"))
	reflect:set("defender", damage:get("attacker"))
	reflect:set("modify_target", "hit_point")
	reflect:set("operate", "-")
	reflect:set("value", dp)
	reflect:onEffect()
end

return BReflect
