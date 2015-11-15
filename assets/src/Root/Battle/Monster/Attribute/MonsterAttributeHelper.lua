----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：视图helper
----------------------------------------------------------------------

local MonsterAttributeHelper = class("MonsterAttributeHelper", Child)

MonsterAttributeHelper.FOLDER = "Attribute"

-- 构造
function MonsterAttributeHelper:ctor()
	MonsterAttributeHelper.super.ctor(self)
end

-- 初始化
function MonsterAttributeHelper:init(args)
    require(self:getRelativePath()..".AttributeBase")
    local config = args.config
    self:createComponent("Impl.HitPoint", config)
    self:createComponent("Impl.ActionBar", config)
end

function MonsterAttributeHelper:createComponent(name, args)
	local path = self:getRelativePath().."."..name
	self:getRoot():createChild(path, args)
end

return MonsterAttributeHelper
