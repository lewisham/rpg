----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2015-4-28
-- 描述：特效模型
----------------------------------------------------------------------

local Effect = class("Effect", function (name) return ccs.Armature:create(name) end)

function Effect.create(name, dir)
    dir = dir or 1
    local path = "effect/"..name.."/"..name..".ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
    local ret = Effect.new(name)
    ret:init()
    ret:initDirection(dir)
    return ret
end

-- 构造函数
function Effect:ctor()
end

-- 初始化
function Effect:init()
	self:listenMovementEvent()
end

-- 初始化朝向并初始脚上位置
function Effect:initDirection(dir)
	local sx = dir < 0 and 1 or -1
	self:setScaleX(sx)
end

function Effect:loopPlay()
    local total = self:getAnimation():getMovementCount()
    local idx = 0
    local playFunc = nil

    local function callback(name)
        idx = idx + 1
        if idx >= total then
            idx = 0
        end
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

-- 监听动画回调事件
function Effect:listenMovementEvent()
	local function onMovementEvent(armature, movementType, movementID)
        --print(movementType, movementID)
		if movementType == ccs.MovementEventType.complete then
            SKEvent.post(SK_EVENT.Movement_Complete, self)
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
function Effect:listenFrameEvent()
	local function onFrameEvent(bone, evt, originFrameIndex, currentFrameIndex)
		if evt == nil then
			return
		end
        SKEvent.post(SK_EVENT.Frame_Event, self)
		if self.mFrameEventHandler then
			self.mFrameEventHandler(evt)
		end
	end
	self:getAnimation():setFrameEventCallFunc(onFrameEvent)
end

-- 播放动画
function Effect:playAnimate(name, loop, animateEndHandler, frameEventHandler)
	self.mAnimateEndHandler = animateEndHandler
	self.mFrameEventHandler = frameEventHandler
	self:getAnimation():play(name, 0, loop)
	return true
end

return Effect
