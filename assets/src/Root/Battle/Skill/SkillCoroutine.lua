----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能协程
----------------------------------------------------------------------

local SkillCoroutine = class("SkillCoroutine", Coroutine)

-- 创建协程
function SkillCoroutine.createCoroutine(func, finishFunc, finishParam)
    local ret = SkillCoroutine.new()
    ret:init(func)
    ret.mFinishFunc = finishFunc
    ret.mFinishParam = finishParam
    return ret
end

-- 开启协程
function SkillCoroutine.startCoroutine(target, name, args)
    local func = target[name]
    if func == nil then
        print("start coroutine can't find function name by", name)
        return false
    end
    local co = nil
    local function excuteFunc()
        xpcall(function() func(target, co, args) end, __G__TRACKBACK__)
    end
    co = SkillCoroutine.createCoroutine(excuteFunc)
    co:run()
    return co
end

-- 等待事件
function SkillCoroutine:waitForEvent(id, obj)
    local function callback(args)
        self:resume("waitForEvent")
    end
    SKEvent.create(id, obj, callback)
    self:pause("waitForEvent")
end


return SkillCoroutine
