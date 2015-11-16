----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：角色类
----------------------------------------------------------------------

local Monster = class("Monster", Root)

Monster.ROOT_PATH = "Root.Battle.Monster"

require(Monster.ROOT_PATH..".Base.AttributeBase")

-- 构造函数
function Monster:ctor()
    Monster.super.ctor(self)
end

-- 初始化
function Monster:init(args)
    self._args = args
    self:addChild("GroupID", args.group)
    -- 创建属性
    self:createComponent("Attribute.HitPoint", args.config)
    self:createComponent("Attribute.Atk", args.config)
    self:createComponent("Attribute.ActionBar", args.config)

    -- 创建视图
	self:createComponent("ActionSprite.ActionSprite", args)
    self:createComponent("StatusBar.MStatusBar", args)
    self:createComponent("Tips.HPTips")

    self:createComponent("State.MState")

    -- 创建技能
    self:createSkill("Root.Battle.Skill.Impl."..args.config.skill)
end

function Monster:createSkill(path)
    self:createChild(path, {monster = self}, "Skill1")
end

return Monster