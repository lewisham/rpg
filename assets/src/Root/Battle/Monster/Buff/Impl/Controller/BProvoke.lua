----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：挑衅
----------------------------------------------------------------------

local BProvoke = class("BProvoke", BuffBase)

-- 构造
function BProvoke:ctor()
	BProvoke.super.ctor(self)
end

-- 初始化
function BProvoke:init(helper, config)
	BProvoke.super.init(self, helper, config)
	self:register(BATTLE_EVENT.Knockout)
end

-- 解析筛选参数
function BProvoke:parseFilterParamter(msg)
	self.mFilterMonster = msg:get("monster")
end

-- 作用目标判定
function BProvoke:filter()
	if self.mFilterMonster == self:get("caster") then
		return true
	end
	return false
end

-- 执行
function BProvoke:execute(msg)
	--lewisPrint("remove provoke buff")
	self:onCleanup()
end

--  更新逻辑
function BProvoke:logic(event)
	event:set("default_target", self:get("caster"))
end

return BProvoke
