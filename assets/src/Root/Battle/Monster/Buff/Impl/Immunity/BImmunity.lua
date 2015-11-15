----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：免役buff
----------------------------------------------------------------------

local BImmunity = class("BImmunity", BuffBase)

-- 构造
function BImmunity:ctor()
	BImmunity.super.ctor(self)
	self.mList = {}		--免役的buff列表
	self.mFilter = "list"
end

-- 初始化
function BImmunity:init(helper, config)
	BImmunity.super.init(self, helper, config)
	-- 解析参数
	local param = "all_debuff"
	if param == "all_buff" or param == "all_debuff" then
		--lewisPrint("immunity all", param)
		self.mFilter = param
	else
		self.mList = Common.splitNumber(param)
		--Log(self.mList)
	end

	-- 监听生成buff事件
	self:register(BATTLE_EVENT.On_Buff)
end

-- 解析筛选参数
function BImmunity:parseFilterParamter(msg)
	self.mFilterMonster = msg:get("monster")
end

-- 执行
function BImmunity:execute(msg)
	local id = msg:get("buff_config_id")
	local buffConfig = ConfigMgr.getConfig("buff_config",id)
	--lewisPrint("event immunity buff2")
	if self.mFilter == "list" then
		for key, val in pairs(self.mList) do
			if val == id then
				msg:set("immunity_buff", true)
				--lewisPrint("immunity buff", id)
				break
			end
		end
	elseif self.mFilter == "all_debuff" then
		if buffConfig.type == 1 then
			msg:set("immunity_buff", true)
		end
	elseif self.mFilter == "all_buff" then
		if buffConfig.type == 0 then
			msg:set("immunity_buff", true)
		end
	end
end

return BImmunity