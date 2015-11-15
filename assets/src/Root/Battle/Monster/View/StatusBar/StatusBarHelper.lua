----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：怪物属性状态栏helper
----------------------------------------------------------------------

local StatusBarHelper = class("StatusBarHelper", Child)

-- 初始化
function StatusBarHelper:init(args)
	self:createBrother("View.StatusBar.Impl.MonsterStatusBar", args)
end


return StatusBarHelper