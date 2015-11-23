----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：根结点
----------------------------------------------------------------------

Root = class("Root", LuaObject)

Root.ROOT_PATH = ""
Root.FOLDER = ""

local mRootList = {}

-- 构造函数
function Root:ctor()
	Root.super.ctor(self)
	self.mChildren = {}
end

function findObject(name)
    return mRootList["Scene"]:getChild(name)
end

function Root:init()
end

function Root:cleanup()
end

-- 从场景中移除
function Root:removeFromScene()
    for _, child in pairs(self.mChildren) do
    end
    self:release()
end

function Root:createScene(path, args, name)
    local cls = require(path)
	local ret = cls.new()
    mRootList["Scene"] = ret
	ret._root = self
    name = name or ret.__cname
    self.mChildren[name] = ret
	ret:init(args)
	ret.__path = path
    return ret
end

function Root:createChild(path, args, name)
	local cls = require(path)
	local ret = cls.new()
	ret._root = self
    name = name or ret.__cname
    self.mChildren[name] = ret
	ret:init(args)
	ret.__path = path
    return ret
end

function Root:addChild(name, child)
    self.mChildren[name] = child
end

function Root:createComponent(name, args)
	local path = self.ROOT_PATH.."."..name
	self:createChild(path, args)
end

function Root:getChild(name)
	return self.mChildren[name]
end

function Root:removeChild(name, args)
    local child = self.mChildren[name]
    if child == nil then return end
    self.mChildren[name] = nil
    child:removeFromScene(args)
end

function createObject(path, args)
    local ret = require(path).new()
    ret:init(args)
    return ret
end


return Root