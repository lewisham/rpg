----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能伤害事件中心
----------------------------------------------------------------------

local SModifyHitPoint = class("SModifyHitPoint", Component)
_G["SModifyHitPoint"] = SModifyHitPoint

local mInstance = nil

function SModifyHitPoint:getInstance()
    return mInstance
end

function SModifyHitPoint:ctor()
    mInstance = self
    self.mMap = {}
end

function SModifyHitPoint:post(damage)
    for _, val in pairs(self.mMap) do
        val.handler(damage)
    end
end

function SModifyHitPoint:register(monster, handler, priority)
    local unit = {}
    unit.monster = monster
    unit.handler = handler
    unit.priority = priority or 0
    table.insert(self.mMap, unit)
end

return SModifyHitPoint
