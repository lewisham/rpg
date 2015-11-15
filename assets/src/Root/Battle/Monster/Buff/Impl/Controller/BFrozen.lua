----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：冻结
----------------------------------------------------------------------

local BFrozen = class("BFrozen", BuffBase)

-- 初始化
function BFrozen:init(helper, config)
	BFrozen.super.init(self, helper, config)
	self:changeState("frozen")
	self:onState(MONSTER_STATE.MS_Frozen, true)
end

-- 清除buff
function BFrozen:onCleanup()
	BFrozen.super.onCleanup(self)
	self:changeState("frozen", true)
	self:playEffectOnMonster("100;4")
	self:onState(MONSTER_STATE.MS_Frozen, false)
end

return BFrozen