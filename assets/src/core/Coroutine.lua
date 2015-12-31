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
function StartCoroutine(target, name, args)
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
    return co
end

-- 构造函数
function Coroutine:ctor()
    self.mId = 0
    self.coroutine = nil
    self.mFinishFunc = nil
    self.mFinishParam = nil
    self.mSchedulerId = nil
    self.mUpdateHandler = nil
    self.mResumeResult = false
end

function Coroutine:init(func)
    local scheduler = cc.Director:getInstance():getScheduler()
    self.mSchedulerId = scheduler:scheduleScriptFunc(function(dt) self:update(dt) end, 0, false)
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

-- 更新
function Coroutine:update(dt)
    if self.mUpdateHandler then
        self.mUpdateHandler(dt)
    end
end

-- 设置更新回调
function Coroutine:setUpdateHandler(handler)
    self.mUpdateHandler = handler
end

-- 恢复
function Coroutine:resume(name)
    self.mUpdateHandler = nil
    if self.mWaitName ~= name then
        print("resume error", self.mWaitName, name)
        return
    end
    local success, yieldType, yieldParam = coroutine.resume(self.coroutine, self)
    --print(success, name, coroutine.status(self.coroutine))
    if not success then
        print("resume failed", success, yieldType, yieldParam)
        self:cleanup()
        return
    end

    local status = coroutine.status(self.coroutine)
    -- 判断协程是否结束
    if status == "dead" then
    	self:cleanup()
    end
end

-- 暂停
function Coroutine:pause(name)
    self.mWaitName = name
    self.mResumeResult = true
    coroutine.yield()
    return self.mResumeResult
end

-- 中断
function Coroutine:interrupt()
end

return Coroutine
