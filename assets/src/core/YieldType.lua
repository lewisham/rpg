----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：协程等待类型
----------------------------------------------------------------------

----------------------
-- 等待数秒
----------------------
function WaitForSeconds(co, seconds)
    local function update(dt)
        seconds = seconds - dt
        if seconds <= 0 then
            co:resume("WaitForSeconds")
        end
    end
    co:setUpdateHandler(update)
    return co:pause("WaitForSeconds")
end

----------------------
-- 等待数帧
----------------------
function WaitForFrames(co, frames)
    local function update(dt)
        frames = frames - 1
        if frames <= 0 then
            co:resume("WaitForFrames")
        end
    end
    co:setUpdateHandler(update)
    return co:pause("WaitForFrames")
end

----------------------
-- 等待函数结果(检查某个变量值)
----------------------
function WaitForFuncResult(co, func)
    local function update(dt)
        if func() then
            co:resume("WaitForFuncResult")
        end
    end
    co:setUpdateHandler(update)
    return co:pause("WaitForFuncResult")
end

----------------------
-- 等待表现事件
----------------------
function WaitForDisplayEvent(co, id, obj)
    local function callback(args)
        co:resume("WaitForDisplayEvent")
    end
    SDisplayEvent.create(id, obj, callback)
    return co:pause("WaitForDisplayEvent")
end

----------------------
-- 等待模型动作播放完毕
----------------------
function WaitForModelAnimate(co, model, name)
    local function animateEndHandler()
        co:resume("WaitForModelAnimate")
    end
    model:playAnimate(name, 0, animateEndHandler)
    return co:pause("WaitForModelAnimate")
end

----------------------
-- 等待怪物移动到
----------------------
function WaitForMonsterMoveTo(co, monster, pos, duration, name)
    local function callback()
        monster:findComponent("ActionSprite"):changeState("idle")
        monster:findComponent("ActionSprite"):setOrginPosition(pos)
        co:resume("WaitForMonsterMoveTo")
    end
    local tb = 
    {
        cc.MoveTo:create(duration, pos),
        cc.CallFunc:create(callback, {}),
    }
    local node = monster:findComponent("ActionSprite")
    node:runAction(cc.Sequence:create(tb))
    local model = monster:findComponent("ActionSprite").mModel
    name = name or "front"
    model:playAnimate(name, 1)
    return co:pause("WaitForMonsterMoveTo")
end
