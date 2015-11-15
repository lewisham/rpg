----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：状态提示信息helper
----------------------------------------------------------------------

local StatusTipsHelper = class("StatusTipsHelper", Child)

-- 初始化
function StatusTipsHelper:init()
	self:createTips("DamageTips")
end

-- 创建子结点
function StatusTipsHelper:createTips(path, name)
	self:createBrother("View.StatusTips.Impl."..path)
end

return StatusTipsHelper