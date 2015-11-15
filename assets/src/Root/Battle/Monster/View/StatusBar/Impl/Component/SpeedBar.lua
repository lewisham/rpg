----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：速度条
----------------------------------------------------------------------

local SpeedBar = class("SpeedBar", Child)

-- 构造
function SpeedBar:ctor()
	SpeedBar.super.ctor(self)
	self.mSprite = nil
	self.mOrginPercentage = 100
	self.mMonster = nil
end


-- 初始化
function SpeedBar:init(args)
	local root = args.root
	local node = root:getChildByName("hp_bg")
	local sprite = node:getChildByName("attack_speed_bar")
	-- 创建尺寸结点
	if args.isBoss then
		local layer = cc.Layer:create()
		sprite:getParent():addChild(layer)
		layer:setAnchorPoint(0, 0)
		local scaleX = cc.Director:getInstance():getWinSize().width / 960
		layer:setScaleX(scaleX)
		
		sprite:removeFromParent(false)
		layer:addChild(sprite)
	end
	
	self.mSprite = sprite
end

--　更新
function SpeedBar:update(percentage)
	if self.mOrginPercentage == percentage then
		return
	end
	self.mOrginPercentage = percentage  
	local size = self.mSprite:getTexture():getContentSize()
	self.mSprite:setTextureRect(cc.rect(0, 0, size.width * percentage / 100, size.height))
end

return SpeedBar