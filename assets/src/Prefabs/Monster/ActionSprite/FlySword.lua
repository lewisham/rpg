----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：飞剑
----------------------------------------------------------------------

local FlySword = NodeDef("FlySword", "Layout/Monster/FlySword/FlySword.csb")


function FlySword:init()
    self:onCreate()
    self.particle:setPositionType(cc.POSITION_TYPE_FREE)
end

return FlySword
