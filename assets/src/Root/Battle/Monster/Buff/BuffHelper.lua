----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：Buff助手
----------------------------------------------------------------------

require "Root.Battle.Monster.Buff.BuffEvent"
require "Root.Battle.Monster.Buff.BuffBase"
require "Root.Battle.Monster.Buff.BuffMgr"

local BuffHelper = class("BuffHelper", MonsterComponent)

-- 创建
function BuffHelper.create(monster)
	local helper = BuffHelper.new()
	helper.mMonster = monster
	helper:init()
	return helper
end

-- 构造
function BuffHelper:ctor()
	BuffHelper.super.ctor(self)
	self.mBuffList	= {}
end

-- 初始化
function BuffHelper:init()
end

-- 获得buff列表
function BuffHelper:getBuffList()
	return self.mBuffList
end

function BuffHelper:reset()
	for key, val in pairs(self.mBuffList) do
		if val:get("alive") then
			val:onCleanup()
		end
	end
	self.mBuffList	= {}
	self:cleanupAllBuffIcon()
end

-- 强制清除所有buff icon()
function BuffHelper:cleanupAllBuffIcon()
	local view = self:getComponent("BuffIconVec")
	if view == nil then
		return
	end
	view:removeAll()
end

-- 加入buff
function BuffHelper:logic(config, caster)
	--config.config_id = 301
	
	-- 当前角色被K.O时不上buff
	if self.mMonster:isKnockout() then
		return
	end
	
	-- 计算抵抗效果
	if self:calcResistance(caster) then
		return
	end
	
	local buffConfig = ConfigMgr.getConfig("buff_config",config.config_id)
	-- 设置buff默认参数
	if config.param == 0 then
		config.param = buffConfig.default_param
	end
	
	-- 判断是否有重叠的buff
	if buffConfig.overlapped == 0 and self:calcOverlapped(caster, buffConfig, config) then
		return
	end
	
	-- 是否免役当前buff
	if SkillEventMgr.postOnBuff(self.mMonster, config.config_id) then
		return false
	end
	
	self:createBuff(caster, buffConfig, config)
	
	return true
end

--------------------------------------
-- 上buff流程
--------------------------------------

-- 效果抵抗
function BuffHelper:calcResistance(caster)
	if caster == nil then
		return false
	end
	
	-- 计算抵抗效果
	if Formula.calcResistance(caster, self.mMonster) then
		-- 效果抵抗
		self:playResistanceTips()
		return true
	end
	return false
end

-- 是否可重叠buff
function BuffHelper:calcOverlapped(caster, buffConfig, config)
	local buff = nil
	for key, val in pairs(self.mBuffList) do
		if val:get("alive") and val.mBuffConfig.id == buffConfig.id then
			buff = val
			break
		end
	end
	
	if buff == nil then
		return false
	end
	
	-- 角色身上已有该buff
	buff:set("caster", caster)
	buff:set("new", true)
	buff:reset(config)
	buff:updateIcon()
	return true
end

-- 生成buff
function BuffHelper:createBuff(caster, buffConfig, config)
	-- 上buff成功事件
	SkillEventMgr.postCreateBuffSuccess(self.mMonster, config.config_id)
	
	--lewisPrint("create buff", config.name)
	local buff = BuffMgr.create(buffConfig)
	buff:set("caster", caster)
	buff:init(self, config)
	buff:createBuffIcon()
	table.insert(self.mBuffList, buff)
	
	-- 播放上buff成功
	self:playOnBuffTips(buffConfig)

end


------------------------------------------------

-- 回合更新
function BuffHelper:onStep(position)
	local event = BuffEvent.new()
	local buffNameList = {}
	
	local cnt = 0
	
	-- 回合更新
	for key, val in pairs(self.mBuffList) do
		if val:get("alive") then
			event:updateConfig(val.mBuffConfig)
			val:onStep(position, event)
		end
		if val:get("alive") then
			cnt = cnt + 1
		end
	end
	
	-- 移除未清除的buff
	self:removeKnockoutBuff()
	
	if cnt < 1 then
		self:cleanupAllBuffIcon()
	end
	return event
end

-- 移除已死亡的buff
function BuffHelper:removeKnockoutBuff()
	local bBreak = true
	while true do
		bBreak = true
		for key, val in pairs(self.mBuffList) do
			if not val:get("alive") then
				table.remove(self.mBuffList, key)
				bBreak = false
				break
			end
		end
		
		if bBreak then
			break
		end
	end
end

-- 搜寻指定名字buff数量
function BuffHelper:getCountWithName(name)
	local cnt = 0
	for key, val in pairs(self.mBuffList) do
		if val:get("alive") then
		end
	end
	return cnt
end

-- 获得buff个数
function BuffHelper:getBuffCnt()
	local cnt = 0
	for key, val in pairs(self.mBuffList) do
		if val:get("alive") and val.mBuffConfig.type == 0 then
			cnt = cnt + 1
		end
	end
	return cnt
end

-- 获得debuff数
function BuffHelper:getDebuffCnt()
	local cnt = 0
	for key, val in pairs(self.mBuffList) do
		if val:get("alive") and val.mBuffConfig.type == 1 then
			cnt = cnt + 1
		end
	end
	return cnt
end

-- 是否存在buff通过buff_config_id匹配
function BuffHelper:isExistBuffByConfigId(id)
	for key, val in pairs(self.mBuffList) do
		if val:get("alive") then
			if val.mBuffConfig.id == id then
				return true
			end
		end
	end
	return false
end

-- 条件选择buff
function BuffHelper:selectBuffByCondition(filter, type)
	local list = {}
	if filter == "all" then
		for key, val in pairs(self.mBuffList) do
			if val:get("alive") and type == val.mBuffConfig.type then
				table.insert(list, val)
			end
		end
	elseif filter == "random" then
		local keys = {}
		--获取对应的buff
		for key, val in pairs(self.mBuffList) do
			if val:get("alive") and type == val.mBuffConfig.type then
				table.insert(keys, key)
			end
		end
		local count = #keys
		if count > 0 then
			local idx = keys[PseudoRandom.random(1,count)]
			table.insert(list, self.mBuffList[idx])
		end
	else
		local ids = Common.splitNumber(filter)
		for _, id in pairs(ids) do
			for key, val in pairs(self.mBuffList) do
				if val:get("alive") and id == val.mBuffConfig.id then
					table.insert(list, val)
				end
			end
		end
	end
	return list
end

-----------------------------------------
-- 视图
-----------------------------------------

-- 上buff提示
function BuffHelper:playOnBuffTips(config)
	if config.on_buff_tips == 0 then
		return
	end
	
	local tips = self:getComponent("on_buff_tips")
	if tips == nil then
		return
	end
	
	local displayList = self:getData("DisplayList")
	if displayList == nil then
		self:implPlayOnBuffTips(config)
		return
	end
	-- 添加到显示列表
	displayList:addDisplayNode(self, BuffHelper.implPlayOnBuffTips, config)
	
end

-- 上buff提示实现
function BuffHelper:implPlayOnBuffTips(config)
	self:getComponent("on_buff_tips"):play(config.on_buff_tips, config.type, config.tips_pic)
end

-- 上buff抵抗提示
function BuffHelper:playResistanceTips()
	local tips = self:getComponent("on_buff_tips")
	if tips == nil then
		return
	end
	local displayList = self:getData("DisplayList")
	if displayList == nil then
		self:implPlayResistanceTips()
		return
	end
	-- 添加到显示列表
	displayList:addDisplayNode(self, BuffHelper.implPlayResistanceTips, nil)
end

-- 上buff抵抗提示实现
function BuffHelper:implPlayResistanceTips()
	self:getComponent("on_buff_tips"):playResistance()
end

return BuffHelper