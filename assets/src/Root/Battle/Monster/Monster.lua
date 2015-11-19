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
    self:addChild("FIdx", args.fidx)
    self:addChild("Phantasm", false)
    -- ��������
    self:createComponent("Attribute.HitPoint", args.config)
    self:createComponent("Attribute.Atk", args.config)
    self:createComponent("Attribute.ActionBar", args.config)

    -- ������ͼ
	self:createComponent("ActionSprite.ActionSprite", args)
    self:createComponent("StatusBar.MStatusBar")
    self:createComponent("Tips.HPTips")

    self:createComponent("State.MState")

    -- ��������
    self:createSkill("Root.Battle.Skill.Impl."..args.config.model.skill)

end

function Monster:createSkill(path)
    self:createChild(path, {monster = self}, "Skill1")
end

-- ˵��
function Monster:speak(str)
    if self:getChild("UIChatPanel") == nil then
       self:createComponent("Speaker.UIChatPanel")
    end
    local dir = self:getChild("ActionSprite").mDir
    self:getChild("UIChatPanel"):speak(dir, str)
end

function Monster:destroy()
    self:getChild("ActionSprite"):removeFromParent(true)
    self:release()
end

return Monster