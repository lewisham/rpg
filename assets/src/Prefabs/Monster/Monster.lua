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
    self:addComponent("KnockOutType", 0)
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
    --self:createSkill("Root.Battle.Skill.Impl."..args.config.model.skill)

end

function Monster:createSkill(path)
    self:createComponent(path, {monster = self}, "Skill1")
end

-- ˵��
function Monster:speak(str)
    if self:getComponent("UIChatPanel") == nil then
       self:createComponent("Speaker.UIChatPanel")
    end
    local dir = self:getComponent("ActionSprite").mDir
    self:getComponent("UIChatPanel"):speak(dir, str)
end

function Monster:onKnockout()
    self:getComponent("HitPoint"):onKnockout()
    self:getComponent("ActionBar"):empty()
    if self:getComponent("KnockOutType") == 0 then
        self:getComponent("ActionSprite"):changeState("dead")
        return
    end
    local function callback()
        self:removeFromScene()
    end
    local dir = self:getComponent("GroupID") == 1 and -1 or 1
    self:getComponent("ActionSprite"):escape(dir, callback)
end

function Monster:removeFromScene()
    self:getComponent("ActionSprite"):removeFromParent(true)
    self:release()
end

return Monster