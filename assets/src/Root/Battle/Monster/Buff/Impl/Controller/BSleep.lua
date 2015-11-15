----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：睡眠
----------------------------------------------------------------------

local BSleep = class("BSleep", BuffBase)

-- 构造
function BSleep:ctor()
	BSleep.super.ctor(self)
end

-- 初始化
function BSleep:init(helper, config)
	BSleep.super.init(self, helper, config)
	self:changeState("sleep")
	self:onState(MONSTER_STATE.MS_Sleep, true)
	-- 监听被击事件
	local center = self:getData("SkillEventCenter")
	center:subscribe(BATTLE_EVENT.Before_Settle_Damage, self, BSleep.handleBeforeDamage, BATTLE_EVENT_PRIORITY_HIGHEST)
end

-- 处理被击事件
function BSleep:handleBeforeDamage(msg)
	local damage = msg:get("damage")
	--只结算扣血伤害
	if damage:get("modify_target") ~= "hit_point" or damage:get("operate") ~= "-" then
		return
	end
	local monster = damage:get("defender")
	if self.mBuffHelper.mMonster ~= monster then
		return
	end
	--把魔灵设成清醒状态
	self:onCleanup()
end

-- 清除buff
function BSleep:onCleanup()
	BSleep.super.onCleanup(self)
	self:changeState("sleep", true)
	self:playEffectOnMonster("100;4")
	self:onState(MONSTER_STATE.MS_Sleep, false)
end

return BSleep