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
    self.mSceneName = "Scene.City.SYuMengLing"--"Scene.CG.SOpeningCG"
end

function Player:play()
    SceneHelper:getInstance():runningScene(self.mSceneName)
end

function Player:goHome()
    SceneHelper:getInstance():replaceScene("Scene.City.SYuMengLing")
end

function Player:gotoEscort()
    SceneHelper:getInstance():replaceScene("Scene.Battle.SMonsterEdit")
    --SceneHelper:getInstance():replaceScene("Scene.Battle.SEscortAgency")
end

