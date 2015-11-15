----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：Buff事件,更新buff表生成的事件
----------------------------------------------------------------------

BuffEvent = class("BuffEvent", LuaObject)

---构造
function BuffEvent:ctor()
	BuffEvent.super.ctor(self)
	self.mProperty["stop_round"] = 0		--回合中止
	self.mProperty["default_target"] = nil	--默认的目标
	self.mProperty["hit_point_modify_list"]   = {}		--中毒或恢复修改的生命值表
	self.mProperty["hit_point"] = 0
end

--更新
function BuffEvent:updateConfig(config)
	--回合中止引用计数+1
	self:operate("stop_round", config.stop_round)
end