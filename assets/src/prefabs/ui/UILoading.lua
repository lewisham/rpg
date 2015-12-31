----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：加载资源中
----------------------------------------------------------------------

local UILoading = class("UILoading", UIBase)

UILoading._uiFileName = "Layout/Loading/Loading.csb"

function UILoading:init(args)
    self:onCreate()
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
            self:preloadMonsterRes(args[idx])
            idx = idx + 1
            to = math.floor(idx / total * 100)
        end
	end
	self:scheduleUpdateWithPriorityLua(update, 0)
end

function UILoading:play(co)
    WaitForFuncResult(co, function() return self.loaded end)
end

function UILoading:preloadMonsterRes(id)-- 预加载怪物资源
    local config = monster_model[monster_config[id].model_id]
    local name = config.model
	local path = "monster/"..name.."/"..name..".ExportJson"

    -- 加载模型
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)

    -- 加载技能音效
    local list = require("Prefabs.Skill.Impl."..config.skill_script).sound_file_list
    for _, val in pairs(list) do
        local id = cc.SimpleAudioEngine:getInstance():preloadEffect(val)
        --print("sound id", id)
    end
end

return UILoading
