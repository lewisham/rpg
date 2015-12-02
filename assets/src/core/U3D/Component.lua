----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：组件类
----------------------------------------------------------------------

Component = class("Component")

-- 构造函数
function Component:ctor()
    self.mProperty = {}
    self.mRefCnt   = 1
    self.mGameOject = nil
	self.mInstanceId = getInstanceId()
end

function Component:init()
end

-- 获得实例id
function Component:getInstanceId()
	return self.mInstanceId
end

-- 获取缓存数据
function Component:get(name)
    local ret = self.mProperty[name]
    return ret
end

-- 设置缓存数据
function Component:set(name, value)
    self.mProperty[name] = value
end

function Component:release()
    self.mRefCnt = self.mRefCnt - 1
end

-- 弱引用
function Component:getSelf()
    if self.mRefCnt == 0 then return nil end
    return self
end

--------------------------------------
-- 组件操作
--------------------------------------

-- 查找组件
function Component:findComponent(name)
    return self.mGameOject:findComponent(name)
end

-- 查找游戏对象
function Component:findGameObject(name)
end

function Component:removeFromObject(args)
end

return Component