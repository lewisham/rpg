----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：buff管理器
----------------------------------------------------------------------

BuffMgr = {}

local mClassList = {}	--类表

-- 初始化类表
function BuffMgr.init()
	-- 属性修改类buff
	mClassList["attack_up"]				= "BModified"			--攻击力提升
	mClassList["attack_down"]			= "BModified"			--攻击力降低
	mClassList["critical_up"]			= "BModified"			--暴击率提升
	mClassList["critical_down"]			= "BModified"			--暴击率降低
	mClassList["defence_up"]			= "BModified"			--防御力提升
	mClassList["defence_down"]			= "BModified"			--防御力降低
	mClassList["attack_speed_up"]		= "BModified"			--攻击速度提升
	mClassList["attack_speed_down"]		= "BModified"			--攻击速度降低
	mClassList["hit_rate_up"]			= "BModified"			--命中率上升
	mClassList["hit_rate_down"]			= "BModified"			--命中率降低
	mClassList["glancing_hit_up"]		= "BModified"
	mClassList["tenacity_up"]			= "BModified"

	-- 免役类
	mClassList["immunity"]				= "Immunity.BImmunity"			--免役
	mClassList["shield_disable"]		= "Immunity.BShieldDisable"		--无法生成护盾
	
	-- 生命值相关类
	mClassList["invincible"]			= "HitPoint.BInvincible"		--无敌，免役攻击伤害
	mClassList["shield"]				= "HitPoint.BShield"			--护盾
	mClassList["immortal"]				= "HitPoint.BImmortal"			--不死
	mClassList["heal_disable"]			= "HitPoint.BHealDisable"
	mClassList["damage_reflect"]		= "HitPoint.BReflect"			--伤害反弹
	mClassList["protect"]				= "HitPoint.BProtect"			--护卫
	mClassList["continuous_damage"]     = "HitPoint.BDot"
	mClassList["recover"]               = "HitPoint.BHot"

	-- 控制类
	mClassList["stun"]                  = "Controller.BStun"
	mClassList["freeze"]				= "Controller.BFrozen"
	mClassList["sleep"]					= "Controller.BSleep"
	mClassList["provoke"]				= "Controller.BProvoke"			--挑衅

	

	-- 反击
	mClassList["counterattack"]			= "BCounterAttack"
end

-- 获得对应的类
function BuffMgr.getClass(name)
	local path = "Root.Battle.Monster.Buff.Impl."..mClassList[name]
	local ret = require(path)
	assert(ret ~= nil, "create buff error: no define class with id "..name)
	return ret
end

-- 生成UI
function BuffMgr.create(config)
	local buff = nil
	local cls = BuffMgr.getClass(config.name)
	buff = cls.new()
	buff.mBuffConfig = config
	return buff
end

-- 是否是不可操作的buff
function BuffMgr.isUncontrollableBuff(id)
	if id == 301 or id == 302 or id == 303 then
		return true
	end
	return false
end

-- 是否是保护buff
function BuffMgr.isProtectBuff(id)
	if id == 202 or id == 203 or id == 501 or id == 401 or id == 209 then
		return true
	end
	return false
end

BuffMgr.init()

return BuffMgr
