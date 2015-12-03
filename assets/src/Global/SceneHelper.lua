----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：场景管理助手
----------------------------------------------------------------------

SceneHelper = class("SceneHelper")

local mInstance = nil

function SceneHelper:getInstance()
    if mInstance then return mInstance end
    mInstance = SceneHelper.new()
    return mInstance
end

function SceneHelper:ctor()
    self.mRunningScene = nil
end

-- 运行场景
function SceneHelper:runningScene(path, name)
    local scene = self:createScene(path, name)
    self.mRunningScene = scene
end

-- 替换场景
function SceneHelper:replaceScene(path, name)
    self.mRunningScene:destroy()
    local scene = self:createScene(path, name)
    self.mRunningScene = scene
end

-- 创建游戏场
function SceneHelper:createScene(path, name)
    local ret = require(path).new()
    ret:createRoot()
    ret:init()
    return ret
end


