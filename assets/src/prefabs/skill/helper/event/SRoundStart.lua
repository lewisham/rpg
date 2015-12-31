----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：回合开始事件
----------------------------------------------------------------------

local SRoundStart = class("SRoundStart", Component)
_G["SRoundStart"] = SRoundStart

local mInstance = nil

function SRoundStart:getInstance()
    return mInstance
end

function SRoundStart:ctor()
    mInstance = self
    self.mMap = {}
end

function SRoundStart:post(...)
    for _, val in pairs(self.mMap) do
        if val.condition(...) then  
            val.handler(...)
        end
    end
end

function SRoundStart:register(condition, handler, priority)
    local unit = {}
    unit.condition = condition
    unit.handler = handler
    unit.priority = priority or 0
    table.insert(self.mMap, unit)
end

return SRoundStart
