----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能
----------------------------------------------------------------------

local Skill = class("Skill", GameObject)

Skill.ROOT_PATH = "Prefabs.Skill"

-- 构造函数
function Skill:ctor()
    Skill.super.ctor(self)
end

function Skill:init()
    self:createComponent("Event.SModifyHitPoint")
    self:createComponent("Event.SRoundStart")
end

return Skill