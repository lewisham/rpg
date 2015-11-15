----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：style图标 包括等级
----------------------------------------------------------------------


local StyleIcon = class("StyleIcon", Child)

-- 初始化
function StyleIcon:init(args)
	local root = args.root
	local style = 1
	local level = 1

	-- icon
	local icon = root:getChildByName("style_bg")

	--　等级
	level = level or 1
	local text = root:getChildByName("Text_lvl")
	text:setString(level)
	
	text:enableOutline(cc.c4b(0, 0, 0, 255), 2)
end

return StyleIcon