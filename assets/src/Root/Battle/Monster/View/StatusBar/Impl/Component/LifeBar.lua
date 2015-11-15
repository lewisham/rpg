----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：血条
----------------------------------------------------------------------

local LifeBar = class("LifeBar", Child)

-- 构造
function LifeBar:ctor()
	LifeBar.super.ctor(self)
	self.mOrginPercentage = 100
	self._bloodBar = nil
	self._bloodBarClone = nil
	self._bReverse = false
	self._bShake = false
	self._node = nil
	self._orginPos = nil
end


-- 初始化
function LifeBar:init(args)
	local root = args.root
	self._bReverse = args.bReverse
	self._bShake = args.bShake
	local node = root:getChildByName("hp_bg")
	self._node = node
	self._orginPos = cc.p(node:getPosition())
	local sprite = node:getChildByName("hit_point")
	
	local parent = sprite:getParent()
	
	-- 创建尺寸结点
	if args.isBoss then
		local layer = cc.Layer:create()
		sprite:getParent():addChild(layer)
		layer:setAnchorPoint(0, 0)
		local scaleX = cc.Director:getInstance():getWinSize().width / 960
		layer:setScaleX(scaleX)
		parent = layer
	end
	
	
	local pos = cc.p(sprite:getPosition())
	sprite:removeFromParent(false)

	local midPoint = cc.vertex2F(0, 0)
	if self._bReverse then
		midPoint = cc.vertex2F(1, 0)
	end

	local progress = cc.ProgressTimer:create(sprite)
	parent:addChild(progress,4)
	progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	progress:setMidpoint(midPoint)
	progress:setBarChangeRate(cc.p(1,0))
	progress:setPercentage(100)
	progress:setPosition(pos)
	progress:setAnchorPoint(0, 0.5)
	sprite:setPosition(0, 0)
	sprite:setAnchorPoint(0.5, 0.5)
	progress:setColor(cc.c3b(0,255,0))
	self._bloodBar = progress


	sprite = node:getChildByName("hit_point_clone")
	local pos = cc.p(sprite:getPosition())
	sprite:removeFromParent(false)
	local progress = cc.ProgressTimer:create(sprite)
	parent:addChild(progress,3)
	progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	progress:setMidpoint(midPoint)
	progress:setBarChangeRate(cc.p(1,0))
	progress:setPercentage(100)
	progress:setPosition(pos)
	progress:setAnchorPoint(0, 0.5)
	sprite:setPosition(0, 0)
	sprite:setAnchorPoint(0.5, 0.5)
	progress:setColor(cc.c3b(255,0,0))
	self._bloodBarClone = progress
end

-- 更新
function LifeBar:update(percent)
	if self.mOrginPercentage == percent then
		return
	end
	-- 掉血时抖动
	if percent < self.mOrginPercentage then
		self:shake()
	end
	self.mOrginPercentage = percent
	self:change(percent)
end

-- 抖动
function LifeBar:shake()
	if not self._bShake then
		return
	end
	self._node:stopAllActions()
	self._node:setPosition(self._orginPos)
	local offset = 4
	local duration = 0.015
	local tb = 
	{
		cc.MoveBy:create(duration, cc.p(-offset, offset)),
		cc.MoveBy:create(duration, cc.p(offset, -offset)),
		cc.MoveBy:create(duration, cc.p(offset, -offset)),
		cc.MoveBy:create(duration, cc.p(-offset, offset)),
	}
	self._node:runAction(cc.Repeat:create(cc.Sequence:create(tb), 10))
end

function LifeBar:change(percent)
	local _bloodBar = self._bloodBar
	local _bloodBarClone = self._bloodBarClone
	local progressTo
	local progressToClone
	local tintTo
	_bloodBar:stopAllActions()
	_bloodBarClone:stopAllActions()
	if percent <= 0 then
		progressTo = cc.ProgressTo:create(0.1,0)
		progressToClone = cc.ProgressTo:create(0.2, 0)
		_bloodBar:runAction(progressTo)
		_bloodBarClone:runAction(progressToClone)
	elseif percent > 70 then
		progressTo = cc.ProgressTo:create(0.3,percent)
		progressToClone = cc.ProgressTo:create(1,percent)
		_bloodBar:setColor(cc.c3b(0,255,0))
		_bloodBar:runAction(progressTo)
		_bloodBarClone:runAction(progressToClone)
	elseif percent > 50 then
		progressTo = cc.ProgressTo:create(0.3,percent)
		progressToClone = cc.ProgressTo:create(1,percent) 
		tintTo = cc.TintTo:create(0.5,255,196,0)   
		_bloodBar:runAction(cc.Spawn:create(progressTo,tintTo))
		_bloodBarClone:runAction(progressToClone)
	elseif percent > 20 then
		progressTo = cc.ProgressTo:create(0.3,percent)
		progressToClone = cc.ProgressTo:create(1,percent) 
		tintTo = cc.TintTo:create(0.5,255,128,0)   
		_bloodBar:runAction(cc.Spawn:create(progressTo,tintTo))
		_bloodBarClone:runAction(progressToClone)
	elseif percent >= 0 then
		if percent > 0 and percent < 5 then
			percent = 5
		end
		progressTo = cc.ProgressTo:create(0.3,percent)
		progressToClone = cc.ProgressTo:create(1,percent) 
		tintTo = cc.TintTo:create(0.5,255,0,0) 
		_bloodBar:runAction(cc.Spawn:create(progressTo,tintTo))
		_bloodBarClone:runAction(progressToClone)	
	end
end

return LifeBar