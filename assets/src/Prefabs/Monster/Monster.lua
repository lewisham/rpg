----------------------------------------------------------------------
-- ���ߣ�lewis
-- ���ڣ�2013-3-31
-- ��������ɫ��
----------------------------------------------------------------------

local Monster = class("Monster", GameObject)

Monster.ROOT_PATH = "Prefabs.Monster"

require(Monster.ROOT_PATH..".Base.AttributeBase")

-- ���캯��
function Monster:ctor()
    Monster.super.ctor(self)
end

-- ��ʼ��
function Monster:init(args)
    self._args = args
    self:addComponent("GroupID", args.group)
    self:addComponent("KnockOutType", args.config.model.knockout_type or 0)
    self:addComponent("FIdx", args.fidx)
    self:addComponent("Phantasm", false)

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
    self:createSkill("Prefabs.Skill.Impl."..args.config.model.skill)

end

function Monster:createSkill(path)
    self:createComponent(path, {monster = self}, "Skill1", true)
end

-- ˵��
function Monster:speak(str)
    if self:findComponent("UIChatPanel") == nil then
       self:createComponent("Speaker.UIChatPanel")
    end
    local dir = self:findComponent("ActionSprite").mDir
    self:findComponent("UIChatPanel"):speak(dir, str)
end

function Monster:onKnockout()
    self:findComponent("HitPoint"):onKnockout()
    self:findComponent("ActionBar"):empty()
    if self:findComponent("KnockOutType") == 0 then
        self:findComponent("ActionSprite"):changeState("dead")
        return
    end
    local function callback()
        self:removeFromScene()
    end
    local dir = self:findComponent("GroupID") == 1 and -1 or 1
    self:findComponent("ActionSprite"):escape(dir, callback)
end

function Monster:removeFromScene()
    self:findComponent("ActionSprite"):removeFromParent(true)
    self:release()
end

return Monster