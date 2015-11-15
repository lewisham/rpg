----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：角色类
----------------------------------------------------------------------

local Monster = class("Monster", Root)

Monster.ROOT_PATH = "Root.Battle.Monster"

-- 构造函数
function Monster:ctor()
    Monster.super.ctor(self)
end

-- 初始化
function Monster:init(args)
    self._args = args
    self:addChild("GroupID", args.group)
	self:createComponent("View.MonsterViewHelper", args)
    self:createComponent("Attribute.MonsterAttributeHelper", args)
    self:createSkill("Root.Battle.Skill.Impl."..args.config.skill)
end

function Monster:createSkill(path)
    self:createChild(path, {monster = self}, "Skill1")
end

return Monster