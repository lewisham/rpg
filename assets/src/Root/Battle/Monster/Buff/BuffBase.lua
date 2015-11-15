----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：Buff基类
----------------------------------------------------------------------

local BuffBase = class("BuffBase", BattleComponent)
_G["BuffBase"] = BuffBase

-- 构造
function BuffBase:ctor()
	BuffBase.super.ctor(self)
	self.mBuffConfig 		= nil
	self.mProperty["alive"] = true
	self.mProperty["caster"] = nil		-- 施放者
	self.mProperty["new"]	= true		-- 新的buff标志,如果是回合结束后更新的buff,的buff要在第二轮
	self.mConfig 			= nil
	self.mBuffHelper 		= nil
	self.mCurRound 			= 0			-- 剩余回合
	self.mIconView 			= nil
end

-- 初始化
function BuffBase:init(helper, config)
	self.mBuffHelper = helper
	self.mProperty["alive"] = true
	self.mConfig = config
	self.mCurRound = config.round
end

-- 自身逻辑
function BuffBase:logic(event)
end

-- 更新
function BuffBase:onStep(position, event)
	if self.mBuffConfig.step_position ~= position then
		self:set("new", false)
		self:updateIcon()
		return
	end
	-- 回合后更新的buff并且,该buff为新buff,则等到下一回合更新
	if position == BUFF_STEP_POSITION.Round_End then
		if self:get("new") then
			self:set("new", false)
		else
			self.mCurRound = self.mCurRound - 1
		end
	else
		self.mCurRound = self.mCurRound - 1
	end
	self:logic(event)
	if self.mCurRound <= 0 then
		self.mCurRound = 0
		self:onCleanup()
	else
		self:updateIcon()
	end
end

-- 重置
function BuffBase:reset(config)
	self.mProperty["alive"] = true
	self.mConfig = config
	self.mCurRound = config.round
end

-- 清除buff
function BuffBase:onCleanup()
	self:set("alive", false)
	self:getData("SkillEventCenter"):unsubscribeAll(self)
	self:updateIcon()
	self:release()
	self.mIconView = nil
end

-- buff名字
function BuffBase:getName()
	return self.mBuffConfig.name
end

-- 修改持续时间
function BuffBase:modifyDuration(val)
	self.mCurRound = self.mCurRound + val
	if self.mCurRound <= 0 then
		self.mCurRound = 0
		self:onCleanup()
		return
	end
	self:updateIcon()
end

------------------------------------------------------
-- 流程
------------------------------------------------------

-- 是否可以触发
function BuffBase:isCanTrigger()
	if self.mBuffHelper.mMonster:isAlive() == false then
		return false
	end
	return true
end

-- 解析筛选参数
function BuffBase:parseFilterParamter(msg)
	self.mFilterMonster = nil
end

-- 作用目标判定
function BuffBase:filter()
	if self.mFilterMonster == self.mBuffHelper.mMonster then
		return true
	end
	return false
end

-- 执行
function BuffBase:execute(msg)
end

------------------------------------------------------
-- 事件
------------------------------------------------------

-- 注册事件
function BuffBase:register(eventId)
	self:getData("SkillEventCenter"):subscribe(eventId, self, BuffBase.eventHandle)
end

-- 事件处理
function BuffBase:eventHandle(msg)
	-- 是否能触发
	if not self:isCanTrigger() then
		return
	end
	self.mFilterMonster = nil
	-- 解析筛选参数
	self:parseFilterParamter(msg)
	
	-- 事件筛选
	if self:filter() == false then
		return
	end
	
	-- 执行
	local bRet = self:execute(msg)
	if not bRet then
		return
	end
	
	-- 播放buff作用时的提示
	self:playBuffOnEffectTips(self.mBuffConfig.buff_effect_tips)
end

function BuffBase:onState(state, bActive)
	local helper = self.mBuffHelper.mMonster:getComponent("StateHelper")
	if bActive then
		helper:activateState(state)
	else
		helper:deactivate(state)
	end
end

------------------------------------------------------
-- 表现
------------------------------------------------------

-- 改变怪物状态
function BuffBase:changeState(name, bCleanup)
	local view = self.mBuffHelper.mMonster:getComponent("ActionSprite")
	if view == nil then
		return
	end
	local param = {}
	param["name"] = name
	param["bCleanup"] = bCleanup
	local displayList = self:getData("DisplayList")
	if displayList == nil then
		self:implChangeState(param)
		return
	end
	-- 添加到显示列表
	displayList:addDisplayNode(self, BuffBase.implChangeState, param)
end

-- 改变怪物状态实现
function BuffBase:implChangeState(param)
	self.mBuffHelper.mMonster:getComponent("ActionSprite"):changeState(param.name, param.bCleanup)
end

-- buff作用时的文字提示
function BuffBase:playBuffOnEffectTips(text)
	local view = self.mBuffHelper.mMonster:getComponent("BuffOnEffectTips")
	if view == nil then
		return
	end
	if text == "0" then
		return
	end
	local displayList = self:getData("DisplayList")
	if displayList == nil then
		self:implPlayBuffOnEffectTips(text)
		return
	end
	-- 添加到显示列表
	displayList:addDisplayNode(self, BuffBase.implPlayBuffOnEffectTips, text)
end

function BuffBase:implPlayBuffOnEffectTips(text)
	self.mBuffHelper.mMonster:getComponent("BuffOnEffectTips"):play(text)
end

function BuffBase:createBuffIcon()
	local view = self.mBuffHelper.mMonster:getComponent("BuffIconVec")
	if view == nil then
		return
	end
	local view = self.mBuffHelper.mMonster:getComponent("BuffIconVec")
	if view == nil then
		return
	end
	local displayList = self:getData("DisplayList")
	if displayList == nil then
		self:implcreateBuffIcon()
		return
	end
	-- 添加到显示列表
	displayList:addDisplayNode(self, BuffBase.implcreateBuffIcon, nil)
end

function BuffBase:implcreateBuffIcon()
	local view = self.mBuffHelper.mMonster:getComponent("BuffIconVec")
	assert(self.mIconView == nil, "create buff icon error")
	view:createBuffIcon(self)
	view:updatePosition()
end

-- icon 视图操作
function BuffBase:updateIcon()
	local view = self.mBuffHelper.mMonster:getComponent("BuffIconVec")
	if view == nil then
		return
	end
	local param = {}
	param.icon = self.mIconView
	param.alive = self:get("alive")
	param.round = self.mCurRound
	local displayList = self:getData("DisplayList")
	if displayList == nil then
		self:implUpdateIcon(param)
		return
	end
	-- 添加到显示列表
	displayList:addDisplayNode(self, BuffBase.implUpdateIcon, param)
end

function BuffBase:implUpdateIcon(param)
	--assert(self.mIconView ~= nil, "update buff icon error with nil icon view")
	local view = self.mBuffHelper.mMonster:getComponent("BuffIconVec")
	if param.alive then
		view:updateCurrent(param.icon, param.round)
	else
		view:removeBuffIcon(param.icon)
	end
	view:updatePosition()
end

-- 在玩家身上播放特效
function BuffBase:playEffectOnMonster(str)
	local monster = self.mBuffHelper.mMonster
	if monster:isKnockout() then
		return
	end
	local view = monster:getComponent("ActionSprite")
	if view == nil then
		return
	end
	local displayList = self:getData("DisplayList")
	if displayList == nil then
		self:implPlayEffectOnMonster(str)
		return
	end
	-- 添加到显示列表
	displayList:addDisplayNode(self, BuffBase.implPlayEffectOnMonster, str)
end

function BuffBase:implPlayEffectOnMonster(str)
	local tb = Common.splitNumber(str, ";")
	local view = self.mBuffHelper.mMonster:getComponent("ActionSprite")
	local param = {}
	param.id = tb[1]
	param.movementId = tb[2]
	view:changeState("add_effect", false, param)
end


return BuffBase