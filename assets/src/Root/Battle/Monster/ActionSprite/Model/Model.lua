----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2015-4-28
-- 描述：怪物模型
----------------------------------------------------------------------

local Model = class("Model", function (name) return ccs.Armature:create(name) end)

-- 创建
function Model.create(name)
	local ret = Model.new(name)
	ret:init()
	return ret
end

-- 构造函数
function Model:ctor()
    self.mbDump = false
	self.mIdelMovementID = "idle"		-- 待机状态
	self.mFootPos = cc.p(0, 0)
	self.mHitPos = cc.p(0, 0)
	self.mAnimateEndHandler = nil
	self.mFrameEventHandler = nil
end

-- 初始化
function Model:init()
	self:initDirection(-1)
	self:listenMovementEvent()
	self:listenFrameEvent()

	-- 初始化站立位置
	self.mFootPos = self:getBonePosition("shadow") or cc.p(0, 0)
	self.mHitPos = self:getBonePosition("point") or cc.p(0, 0)
	
	self:playAnimate("idle", 1)
    --self:loopPlay()
end

function Model:loopPlay(tb)
    local total = self:getAnimation():getMovementCount()
    tb.idx = tb.idx + 1
    if tb.idx + 1 > total then
        tb.idx = 0
    end
    local idx = tb.idx
    local playFunc = nil

    local function callback(name)
        idx = idx + 1
        if idx >= total then
            idx = 0
        end
        tb.idx = idx
        playFunc()
    end

    local function play()
        self.mAnimateEndHandler = callback
	    self:getAnimation():playWithIndex(idx, -1, 0)
        print("play with idx", idx, self:getAnimation():getCurrentMovementID())
    end
    play()
    playFunc = play
end

function Model:getTall()
	local p1 = self:getBonePosition("shadow") or cc.p(0, 0)
	local p2 = self:getBonePosition("blood") or cc.p(0, 0)
	return p2.y - p1.y
end

-- 初始化朝向并初始脚上位置
function Model:initDirection(dir)
	local sx = dir < 0 and 1 or -1
	self:setScaleX(sx)
end

-- 获得骨骼位置
function Model:getBonePosition(name)
	local bone = self:getBone(name)
	if bone == nil then
		return nil
	end
	local rect = bone:getDisplayManager():getBoundingBox()
	local pos = cc.p(rect.x + rect.width / 2, rect.y + rect.height / 2)
	return pos
end

-- 获得相对shadow的骨骼位置
function Model:getRelativePosition(name)
	local pos
	if false then
		pos = cc.p(self.mHitPos.x, self.mHitPos.y)
	else
		pos = self:getBonePosition(name)
	end
	if pos == nil then
		return cc.p(0, 0)
	end
	local ret = cc.pSub(pos, self.mFootPos)
	if self:getScaleX() < 0 then
		ret.x = -ret.x
	end
	return ret
end

-- 是否存在动画
function Model:isExistAnimate(name)
	local movement = self:getAnimation():getAnimationData():getMovement(name)
	if movement == nil then
		return false
	end
	return true
end

-- 播放动画
function Model:playAnimate(name, loop, animateEndHandler, frameEventHandler)
	if self.mIdelMovementID == "frozen" then
		return false
	end
	if self:isExistAnimate(name) == false then
		return false
	end
	self.mAnimateEndHandler = animateEndHandler
	self.mFrameEventHandler = frameEventHandler
	self:getAnimation():play(name, 0, loop)
	return true
end

-- 监听动画回调事件
function Model:listenMovementEvent()
	local function onMovementEvent(armature, movementType, movementID)
        if self.mbDump then
		    print("onMovementEvent", movementType, movementID, ccs.MovementEventType.complete)
        end
		if movementType == ccs.MovementEventType.complete then
			if self.mAnimateEndHandler then
				local handler = self.mAnimateEndHandler
				self.mAnimateEndHandler = nil
				self.mFrameEventHandler = nil
				handler(movementID)
			end
		end
	end
	self:getAnimation():setMovementEventCallFunc(onMovementEvent)
end

-- 监听帧事件回调事件
function Model:listenFrameEvent()
	local function onFrameEvent(bone, evt, originFrameIndex, currentFrameIndex)
		if evt == nil then
			return
		end
        if self.mbDump then
		    print("evt", evt)
        end
		if self.mFrameEventHandler then
			self.mFrameEventHandler(evt)
		elseif self.mGobalFrameEventParseHandler then
			self.mGobalFrameEventParseHandler(evt)
		end
	end
	self:getAnimation():setFrameEventCallFunc(onFrameEvent)
end

function Model:onHit()
    local function callback()
        self:playAnimate("idle", 1)
    end
    self:playAnimate("hit", 0, callback)
end

return Model