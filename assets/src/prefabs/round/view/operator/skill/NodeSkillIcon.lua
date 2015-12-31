----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动头像
----------------------------------------------------------------------


local NodeSkillIcon = NodeDef("NodeSkillIcon", "Layout/Skill/SkillIcon.csb")


function NodeSkillIcon:init(idx, handler)
    self:onCreate()
    self.mIdx = idx
    self.mHandler = handler
end

function NodeSkillIcon:click_btn_icon()
    self.mHandler(self.mIdx)
end

return NodeSkillIcon
