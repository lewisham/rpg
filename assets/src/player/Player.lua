----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：玩家
----------------------------------------------------------------------

Player = class("Player", GameObject)

local mInstance = nil

function Player:getInstance()
    if mInstance then return mInstance end
    mInstance = Player.new()
    return mInstance
end

function Player:ctor()
    self.mSceneName = "scene.city.SYuMengLing"--"Scene.CG.SOpeningCG"
end

function Player:play()
    SceneHelper:getInstance():runningScene(self.mSceneName)
end

function Player:goHome()
    SceneHelper:getInstance():replaceScene("scene.city.SYuMengLing")
end

function Player:gotoEscort()
    SceneHelper:getInstance():replaceScene("scene.battle.SMonsterEdit")
    --SceneHelper:getInstance():replaceScene("Scene.Battle.SEscortAgency")
end

