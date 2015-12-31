----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏场景
----------------------------------------------------------------------

GameScene = class("GameScene")


local mInstanceId = 0

-- 构造函数
function GameScene:ctor()
    self.mProperty = {}
    self.mGameObjects = {}
    self.mRoot = nil
    self.mRefCnt   = 1
	self.mInstanceId = getInstanceId()
end

function GameScene:init()
end

function GameScene:destroy()
    self.mRoot:removeFromParent(true)
    self.mRoot = nil
    self:release()
end

function GameScene:createRoot()
    local layer = cc.Layer:create()
    g_RootScene:addChild(layer)
    self.mRoot = layer
end

function GameScene:getRoot()
    return self.mRoot
end

-- 获得实例id
function GameScene:getInstanceId()
	return self.mInstanceId
end

-- 获取缓存数据
function GameScene:get(name)
    local ret = self.mProperty[name]
    return ret
end

-- 设置缓存数据
function GameScene:set(name, value)
    self.mProperty[name] = value
end

function GameScene:release()
    self.mRefCnt = self.mRefCnt - 1
end

-- 弱引用
function GameScene:getSelf()
    if self.mRefCnt == 0 then return nil end
    return self
end

--------------------------------------
-- 游戏对象操作
--------------------------------------

-- 创建游戏对象
function GameScene:createGameObject(path, args, name)
    local cls = require(path)
	local ret = cls.new()
    name = name or ret.__cname
    if ret._ui_flag then
        SetClass(ret, GameObject)
        ret.mRoot = self:getRoot() 
    end
    ret.mGameScene = self
    self.mGameObjects[name] = ret
	ret:init(args)
    return ret
end

-- 查找游戏对象
function GameScene:findGameObject(name)
    return self.mGameObjects[name]
end

-- 移除游戏对象
function GameScene:removeGameObject(name, args)
    local obj = self:findGameObject(name)
    if obj == nil then return end
    self.mGameObjects[name] = nil
    obj:removeFromScene(args)
end

-- 打印当前的对象表
function GameScene:dumpGameObject()
    for key, val in pairs(self.mGameObjects) do
        print(key)
    end
end

return GameScene