----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能表现事件中心
----------------------------------------------------------------------

SKEvent = class("SKEvent")

SKEvent.map = {}

SK_EVENT = 
{
    Movement_Complete = 1,
    Frame_Event = 2,
    Missle_Complete = 3,
    Move_Complete = 4,
}

function SKEvent.post(id, obj, args)
    for key, event in pairs(SKEvent.map) do
        if event:judge(id, obj) then
            SKEvent.map[key] = nil
            event:excute(args)
            break
        end
    end
end

local mInstance = 1
function SKEvent.create(id, obj, handler)
    local ret = SKEvent.new()
    ret.mEventId = id
    ret.mObj = obj
    ret.mHandler = handler
    SKEvent.map[mInstance] = ret
    mInstance = mInstance + 1
    return ret
end

-- 构造函数
function SKEvent:ctor()
    self.mEventId = 0
    self.mObj = nil
    self.mHandler = nil
end

function SKEvent:judge(id, obj)
    if id == self.mEventId and self.mObj == obj then
        return true
    end
    return false
end

function SKEvent:excute(args)
    if self.mHandler then
        self.mHandler(args)
        self.mHandler = nil
    end
end

