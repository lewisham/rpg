----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：子结点
----------------------------------------------------------------------

Child = class("Child", Root)



-- 构造函数
function Child:ctor()
	Child.super.ctor(self)
	self._root = nil
end

function Child:init()
end

function Child:getRoot()
	return self._root
end

function Child:getBrother(name)
	return self._root.mChildren[name]
end

function Child:getRelativePath()
	return self._root.ROOT_PATH.."."..self.FOLDER
end

function Child:createBrother(name, args)
    local path = self._root.ROOT_PATH.."."..name
    self:getRoot():createChild(path, args)
end

return Child