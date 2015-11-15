----------------------------------------------------------------------
-- ���ߣ�lewis
-- ���ڣ�2013-3-31
-- ��������ɫ��
----------------------------------------------------------------------

local Monster = class("Monster", Root)

Monster.ROOT_PATH = "Root.Battle.Monster"

-- ���캯��
function Monster:ctor()
    Monster.super.ctor(self)
end

-- ��ʼ��
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