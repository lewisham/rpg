----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏对象
----------------------------------------------------------------------

GameObject = class("GameObject")


local mInstanceId = 0

-- 构造函数
function GameObject:ctor()
    self.mProperty = {}
    self.mComponents = {}
    self.mGameScene = nil
    self.mRefCnt   = 1
	self.mInstanceId = getInstanceId()
end

function GameObject:init()
end

-- 获得实例id
function GameObject:getInstanceId()
	return self.mInstanceId
end

-- 获取缓存数据
function GameObject:get(name)
    local ret = self.mProperty[name]
    return ret
end

-- 设置缓存数据
function GameObject:set(name, value)
    self.mProperty[name] = value
end

function GameObject:release()
    self.mRefCnt = self.mRefCnt - 1
end

-- 弱引用
function GameObject:getSelf()
    if self.mRefCnt == 0 then return nil end
    return self
end

-- 获得添加到的场景
function GameObject:getScene()
    return self.mGameScene
end

--------------------------------------
-- 组件操作
--------------------------------------

-- 从场景中移除
function GameObject:removeFromScene(args)
end

-- 创建组件
function GameObject:createComponent(filename, args, name, bDefinitely)
	local path
    if bDefinitely then
        path = filename
    else
        path = self.ROOT_PATH.."."..filename
    end
    local cls = require(path)
	local ret = cls.new()
    name = name or ret.__cname
    -- ui 组件
    if ret._ui_flag then
        SetClass(ret, Component)
        ret.mRoot = self:getScene():getRoot()
    end
	ret.mGameOject = self
    self.mComponents[name] = ret
    ret.__path = path
	ret:init(args)
    return ret
end

-- 添加组件
function GameObject:addComponent(name, val)
    self.mComponents[name] = val
end

-- 查找组件
function GameObject:findComponent(name)
    return self.mComponents[name]
end

-- 移除组件
function GameObject:removeComponent(args)
    local obj = self:findComponent(name)
    if obj == nil then return end
    self.mComponents[name] = nil
    obj:removeFromObject(args)
end

-- 查找场景中的其他游戏对角
function GameObject:findOtherObject(name)
    return self:getScene():findGameObject(name)
end

return GameObject