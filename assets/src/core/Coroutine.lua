----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：协程
----------------------------------------------------------------------

local Coroutine = class("Coroutine")

local mCoroutineId = 0

-- 创建协程
function Coroutine.createCoroutine(func, finishFunc, finishParam)
    local ret = Coroutine.new()
    ret:init(func)
    ret.mFinishFunc = finishFunc
    ret.mFinishParam = finishParam
    return ret
end

-- 开启协程
function startCoroutine(target, name, args)
    local func = target[name]
    if func == nil then
        print("start coroutine can't find function name by", name)
        return false
    end
    local co = nil
    local function excuteFunc()
        --func(target, co, args)
        xpcall(function() func(target, co, args) end, __G__TRACKBACK__)
    end
    co = Coroutine.createCoroutine(excuteFunc)
    co:run()
end

-- 测试
function Coroutine.coroutineTest()
    local co
    local function test()
        print("coroutine start++++++++++++++++++++++++++")
        co:waitForFrames(5)
        print("wait for frames end+++++++++++++++++++++++++++")
        co:waitForSeconds(1.0)
        print("wait for seconds end+++++++++++++++++++++++++++")
    end
    print("coroutineTest+++++++++++++++++++++++++++")
    co = Coroutine:createCoroutine(test)
    co:run()
end



-- 构造函数
function Coroutine:ctor()
    self.mWaitName = ""
    self.mWaitForFrames = 0
    self.mWaitForSeconds = 0
    self.mId = 0
    self.coroutine = nil
    self.mFinishFunc = nil
    self.mFinishParam = nil
    self.mSchedulerId = nil
end

function Coroutine:init(func)
    self.mSchedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt) self:update(dt) end, 0, false)

    local co = coroutine.create(func)
    self.coroutine = co
    return true
end

function Coroutine:run()
    local co = self.coroutine
    local success, yieldType, yieldParam = coroutine.resume(co, self)
    if not success then
        return false
    end
    
    if coroutine.status(co) == "dead" then
        self:cleanup()
    	return false
    end
end

-- 清除协程
function Coroutine:cleanup()
    if self.mFinishFunc then
        self.mFinishFunc(self.mFinishParam)
    end
    if self.mSchedulerId then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.mSchedulerId)
        self.mSchedulerId = nil
    end
end

function Coroutine:update(dt)
    --print("update", self.mWaitForFrames)
    if self.mWaitForFrames > 0 then
        self.mWaitForFrames = self.mWaitForFrames - 1
        if self.mWaitForFrames <= 0 then
            self:resume("waitForFrames")
        end
    elseif self.mWaitForSeconds > 0 then
        self.mWaitForSeconds = self.mWaitForSeconds - dt
        if self.mWaitForSeconds <= 0 then
            self:resume("waitForSeconds")
        end
    elseif self.mWaitForFuncResult then
        if self.mWaitForFuncResult() then
            self.mWaitForFuncResult = nil
            self:resume("waitForFuncResult")
        end
    end
end

-----------------------------------
-- 接口函数
-----------------------------------

-- 等待数帧
function Coroutine:waitForFrames(frames)
    --print("wait for frames", frames)
    self.mWaitForFrames = frames + 1
    self:pause("waitForFrames")
end

-- 等待数秒
function Coroutine:waitForSeconds(seconds)
    --print("wait for seconds", seconds)
    self.mWaitForSeconds = seconds
    self:pause("waitForSeconds")
end

-- 等待函数返回true
function Coroutine:waitForFuncResult(func)
    self.mWaitForFuncResult = func
    self:pause("waitForFuncResult")
end

-- 等待函数回调
function Coroutine:waitForCallback(func)
    self:pause("waitForCallback")
end

-- 等待动作
function Coroutine:waitForModelAnimate(model, name)
    -- 动作完毕回调
    local function animateEndHandler()
        self:resume("waitForModelAnimate")
    end
    local bRet = model:playAnimate(name, 0, animateEndHandler)
    if bRet then self:pause("waitForModelAnimate") end
end

-- 等待怪物移动到
function Coroutine:waitForMonsterMoveTo(monster, pos, duration, name)
    local function callback()
        monster:findComponent("ActionSprite"):changeState("idle")
        monster:findComponent("ActionSprite"):setOrginPosition(pos)
        self:resume("waitForMonsterMoveTo")
    end
     local tb = 
    {
        cc.MoveTo:create(duration, pos),
        cc.CallFunc:create(callback, {}),
    }
    local node = monster:findComponent("ActionSprite")
    node:runAction(cc.Sequence:create(tb))
    local model = monster:findComponent("ActionSprite").mModel
    name = name or "front"
    model:playAnimate(name, 1)
    self:pause("waitForMonsterMoveTo")
end

-- 恢复
function Coroutine:resume(name)
    --assert(self.mWaitName == name, "resume error")
    if self.mWaitName ~= name then
        print("resume error", self.mWaitName, name)
        return
    end
    local success, yieldType, yieldParam = coroutine.resume(self.coroutine, self)
    if not success then
        print("resume failed", success, yieldType, yieldParam)
        self:cleanup()
        return
    end

    local status = coroutine.status(self.coroutine)
    --print("resume", name, status)
    -- 判断协程是否结束
    if status == "dead" then
    	self:cleanup()
    end
end

function Coroutine:pause(name)
    self.mWaitName = name
    coroutine.yield()
end

return Coroutine
