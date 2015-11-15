----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：lua对象的基类
----------------------------------------------------------------------

LuaObject = class("LuaObject")


local mInstanceId = 0

-- 构造函数
function LuaObject:ctor()
    self.mProperty = {}
    self.mRefCnt   = 1
	mInstanceId = mInstanceId + 1
	self.mInstanceId = mInstanceId + 1
end

function LuaObject:init()
end

-- 获得实例id
function LuaObject:getInstanceId()
	return self.mInstanceId
end

-- 获取缓存数据
function LuaObject:get(name)
    local ret = self.mProperty[name]
    return ret
end

-- 设置缓存数据
function LuaObject:set(name, value)
    self.mProperty[name] = value
end

-- 基本加减法
function LuaObject:operate(name, value)
	self.mProperty[name] = self.mProperty[name] + value
end

function LuaObject:release()
    self.mRefCnt = self.mRefCnt - 1
end

-- 弱引用
function LuaObject:getSelf()
    if self.mRefCnt == 0 then
        return nil
    end
    return self
end

function LuaObject:update(dt)
end

function LuaObject:scheduleUpdate(interval)
	local function update(dt)
		self:update(dt)
	end
	interval = interval or 0
	local id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(update, interval, false)
end

return LuaObject