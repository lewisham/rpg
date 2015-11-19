----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：加载资源中
----------------------------------------------------------------------

local UILoading = NodeDef("UILoading", "Layout/Loading/Loading.csb")

function UILoading:init(args)
    self:onCreate()
    g_BattleRoot:addChild(self)
    local bar = self.bar
    local count = 1
    local idx = 1
    local total = #args
    local percent = 0
    local to = 0
    self.bar:setPercent(percent)
    self.loaded = false
    local function update(dt)
        if percent >= 100 then
            self.loaded = true
            return
        end
        if percent < to then
            percent = percent + 1
            self.bar:setPercent(percent)
        end
        if idx >= total then
            return
        end
        count = count + 1
        if count > 10 then
            count = 0
            preloadMonsterRes(args[idx])
            idx = idx + 1
            to = math.floor(idx / total * 100)
        end
	end
	self:scheduleUpdateWithPriorityLua(update, 0)
end

function UILoading:isDone()
    return self.loaded
end

return UILoading
