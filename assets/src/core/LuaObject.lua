----------------------------------------------------------------------
-- ���ߣ�lewis
-- ���ڣ�2013-3-31
-- ������lua����Ļ���
----------------------------------------------------------------------

LuaObject = class("LuaObject")


local mInstanceId = 0

-- ���캯��
function LuaObject:ctor()
    self.mProperty = {}
    self.mRefCnt   = 1
	mInstanceId = mInstanceId + 1
	self.mInstanceId = mInstanceId + 1
end

function LuaObject:init()
end

-- ���ʵ��id
function LuaObject:getInstanceId()
	return self.mInstanceId
end

-- ��ȡ��������
function LuaObject:get(name)
    local ret = self.mProperty[name]
    return ret
end

-- ���û�������
function LuaObject:set(name, value)
    self.mProperty[name] = value
end

-- �����Ӽ���
function LuaObject:operate(name, value)
	self.mProperty[name] = self.mProperty[name] + value
end

function LuaObject:release()
    self.mRefCnt = self.mRefCnt - 1
end

-- ������
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