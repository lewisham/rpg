----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：晕眩
----------------------------------------------------------------------

local BStun = class("BStun", BuffBase)

-- 构造
function BStun:ctor()
	BStun.super.ctor(self)
end

-- 初始化
function BStun:init(helper, config)
	BStun.super.init(self, helper, config)
	self:changeState("stun", false)
	self:onState(MONSTER_STATE.MS_Stun, true)
	lewisPrint("buff stun")
	Log(config)
end

-- 清除buff
function BStun:onCleanup()
	BStun.super.onCleanup(self)
	self:changeState("stun", true)
	self:playEffectOnMonster("100;4")
	self:onState(MONSTER_STATE.MS_Stun, false)
end

return BStun