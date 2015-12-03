----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏引擎
----------------------------------------------------------------------

Player = class("Player", GameObject)

local mInstance = nil

function Player:getInstance()
    if mInstance then return mInstance end
    mInstance = Player.new()
    return mInstance
end

function Player:ctor()
    self.mSceneName = "Scene.CG.SOpeningCG"
end

function Player:play()
    SceneHelper:getInstance():runningScene(self.mSceneName)
end

