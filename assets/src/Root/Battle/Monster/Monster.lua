----------------------------------------------------------------------
-- ���ߣ�lewis
-- ���ڣ�2013-3-31
-- ��������ɫ��
----------------------------------------------------------------------

local Monster = class("Monster", Root)

Monster.ROOT_PATH = "Root.Battle.Monster"

require(Monster.ROOT_PATH..".Base.AttributeBase")

-- ���캯��
function Monster:ctor()
    Monster.super.ctor(self)
end

-- ��ʼ��
function Monster:init(args)
    self._args = args
    self:addChild("GroupID", args.group)
    -- ��������
    self:createComponent("Attribute.HitPoint", args.config)
    self:createComponent("Attribute.Atk", args.config)
    self:createComponent("Attribute.ActionBar", args.config)

    -- ������ͼ
	self:createComponent("ActionSprite.ActionSprite", args)
    self:createComponent("StatusBar.MStatusBar", args)
    self:createComponent("Tips.HPTips")

    self:createComponent("State.MState")

    -- ��������
    self:createSkill("Root.Battle.Skill.Impl."..args.config.skill)
end

function Monster:createSkill(path)
    self:createChild(path, {monster = self}, "Skill1")
end

return Monster