----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能
----------------------------------------------------------------------
require "prefabs.skill.SKDefine"

local SkillHelper = class("SkillHelper", GameObject)

SkillHelper.ROOT_PATH = "prefabs.skill.helper"

-- 构造函数
function SkillHelper:ctor()
    SkillHelper.super.ctor(self)
end

function SkillHelper:init()
    self:createComponent("effect.EffectRootMgr")
    self:createComponent("event.SModifyHitPoint")
    self:createComponent("event.SRoundStart")
end

return SkillHelper