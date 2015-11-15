----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：护盾
----------------------------------------------------------------------

local BShield = class("BShield", BuffBase)

--构造
function BShield:ctor()
	BShield.super.ctor(self)
	self.mShield = 0
end

--初始化
function BShield:init(helper, config)
	BShield.super.init(self, helper, config)
	--self:changeState("invincible", false)
	self:calcShield(config.param)
	self:register(BATTLE_EVENT.Calc_Shield, BATTLE_EVENT_PRIORITY_HIGHEST)
	--lewisPrint("init shield", self.mShield)
end

function BShield:onStep(position, event)
	BShield.super.onStep(self, position, event)
	--lewisPrint("shield on step", self.mCurRound)
end

-- 重置
function BShield:reset(config)
	self.mCurRound = config.round
	self:calcShield(config.param)
	self.mProperty["alive"] = self.mShield > 0
	lewisPrint("reset shield", self.mShield)
end

-- 计算护盾值
function BShield:calcShield(param)
	self.mShield = 0
	local shield = math.floor(param / 100 * self.mBuffHelper.mMonster:getComponent("HitPoint"):getMax())
	self.mShield = self.mShield + shield
end

-- 解析筛选参数
function BShield:parseFilterParamter(msg)
	self.mFilterMonster = msg:get("damage"):get("defender")
end

-- 执行
function BShield:execute(msg)
	local damage = msg:get("damage")
	-- 只结算扣血伤害
	if damage:get("modify_target") ~= "hit_point" or damage:get("operate") ~= "-" then
		return false
	end
	local dp = damage:get("value")
	local ret = self.mShield - dp
	if ret > 0 then
		self.mShield = ret
		dp = 0
	else
		self.mShield = 0
		dp = math.abs(ret)
	end

	-- 伤害值清0
	--dp = 0

	-- 护盾值不足
	if self.mShield <= 0 then
		self:onCleanup()
	end
	damage:set("value", dp)
	
	-- 信息停止发送
	return true
end

-- 清除buff
function BShield:onCleanup()
	--lewisPrint("cleanup shield", self.mShield)
	--self:changeState("invincible", true)
	BShield.super.onCleanup(self)
end

return BShield