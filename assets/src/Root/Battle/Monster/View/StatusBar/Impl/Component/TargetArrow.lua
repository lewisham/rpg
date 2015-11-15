----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：技能目标选中箭头
----------------------------------------------------------------------


local TargetArrow = class("TargetArrow", Child)

-- 构造
function TargetArrow:ctor()
	TargetArrow.super.ctor(self)
	self._list = {}
end

-- 初始化
function TargetArrow:init(args)
	local root = args.root
	--　箭头
	local sprite = root:getChildByName("target_arrow")
	sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(0, 20)),cc.MoveBy:create(0.2, cc.p(0, -20)))))
	
	-- 闪光
	local flash = root:getChildByName("flash")
	flash:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeTo:create(0.8,0),cc.FadeTo:create(0.3,255))))
	flash:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(0, 20)),cc.MoveBy:create(0.2, cc.p(0, -20)))))
	self.mSprite = sprite
	table.insert(self._list, sprite)
	table.insert(self._list, flash)
	
	self:setVisible(false)
end

-- 显示或隐藏
function TargetArrow:setVisible(bShow)
	for _, sprite in pairs(self._list) do
		sprite:setVisible(bShow)
	end
end

-- 指定一个目标
function TargetArrow:applyFrom(caster)
	self:setVisible(true)
	local filename = Data.gres_array.target_arrow[2]--"UI/Battle/MonsterStatusBar/ui_zdgc_004_2.png"
	if self:getComponent("group") ~= caster:getComponent("group") then
		local ret = Formula.restraint(caster, self.mMonster)
		if ret == 1 then
			filename = Data.gres_array.target_arrow[2]--"UI/Battle/MonsterStatusBar/ui_zdgc_004_2.png"
		elseif ret == -1 then
			filename = Data.gres_array.target_arrow[1]--"UI/Battle/MonsterStatusBar/ui_zdgc_004_1.png"
		else
			filename = Data.gres_array.target_arrow[3]--"UI/Battle/MonsterStatusBar/ui_zdgc_004_3.png"
		end
	end

	Common.spriteReloadTexture(self.mSprite, filename)
end

return TargetArrow