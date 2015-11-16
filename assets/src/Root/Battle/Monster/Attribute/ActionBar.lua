----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：生命值
----------------------------------------------------------------------

local ActionBar = class("ActionBar", AttributeBase)

-- 构造
function ActionBar:ctor()
	ActionBar.super.ctor(self)
    self.mDistance = 0
	self.mSpeed = 0
end

-- 初始化
function ActionBar:init(config)
    self.mSpeed = config.speed
end

function ActionBar:empty()
    self.mDistance = 0
end

function ActionBar:isFull()
    return self.mDistance >= 100
end

function ActionBar:getPrecent()
    return self.mDistance
end

function ActionBar:updatePerFrame()
    if self:isFull() then
        return
    end
    self.mDistance = self.mDistance + self.mSpeed * 0.015
end

return ActionBar
