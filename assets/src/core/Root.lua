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
    mRootList[self.__cname] = self
	Root.super.ctor(self)
	self.mChildren = {}
end

function Root:findRoot(name)
    return mRootList[name]
end

function Root:init()
end

function Root:cleanup()
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

function createObject(path)
    local ret = require(path).new()
    ret:init()
    return ret
end


return Root