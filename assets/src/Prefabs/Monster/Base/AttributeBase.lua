----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：怪物基本属性
----------------------------------------------------------------------

local AttributeBase = class("AttributeBase", Component)
_G["AttributeBase"] = AttributeBase

-- 构造
function AttributeBase:ctor()
	AttributeBase.super.ctor(self)
    self.mCurrent = 0
    self.mMax = 0
end

-- 初始化
function AttributeBase:initConfig(cur, max)
    self.mCurrent = cur
    self.mMax = max
end

function AttributeBase:getPercent()
    return math.floor(self.mCurrent / self.mMax * 100)
end

function AttributeBase:getCurrent()
    return self.mCurrent
end

return AttributeBase
