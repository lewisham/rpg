----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动条
----------------------------------------------------------------------

local ActionBar = class("ActionBar", AttributeBase)

-- 构造
function ActionBar:ctor()
	ActionBar.super.ctor(self)
    self.mDistance = 0
	self.mSpeed = 0
    self.mMovePercent = 0
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

function ActionBar:getPercent()
    local percent = self.mDistance
    if percent > 100 then
        percent = 100
    end
    return percent
end

-- 计算需要多少时间
function ActionBar:calcNeedTime()
    self.mMovePercent = 0
    if self:isFull() then
        return 0
    end
    return (100 - self.mDistance) / self.mSpeed
end

-- 同步进度条
function ActionBar:syncTime(time)
    local add = self.mSpeed * time
    self.mDistance = self.mDistance + add
    self.mMovePercent = add
end

function ActionBar:getMovePercent()
    return self.mMovePercent
end

function ActionBar:afterRound()
    local add = self.mSpeed * 0.05
    self.mDistance = self.mDistance + add
    self.mMovePercent = add
end

return ActionBar
