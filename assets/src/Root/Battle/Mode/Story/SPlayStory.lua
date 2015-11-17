----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：剧情播放
----------------------------------------------------------------------

local SPlayStory = class("SPlayStory", Root)

SPlayStory.ROOT_PATH = "Root.Mode.Story"

-- 初始化
function SPlayStory:init(args)
    createObject("Root.Battle.Scene.BScene")
    startCoroutine(self, "play")
end

local SPEAKER_DURATION = 2.0

function SPlayStory:play(co)
    self.mCoroutine = co
    local m1 = createMonster(103, cc.p(180, 256), 1)
    local m2 = createMonster(104, cc.p(1024 - 180, 256), 2)
    self:createSideMask(0.6)
    co:waitForSeconds(0.6 + 0.8)
    self:playerSpeak(m1,"你为什么要背叛这些年来对你最亲近的人。")
    self:playerSpeak(m1,"难道只是为了那微不足道的金钱。")
    self:playerSpeak(m1,"让你可以在这里为所欲为。")
    self:playerSpeak(m1)
    self:playerSpeak(m2, "就当时的情境，我无法选择，也没有退路。")
    self:playerSpeak(m2)
    self:playerSpeak(m1, "所以你选择了伤害。")
end

-- 创建上下边的黑幕
function SPlayStory:createSideMask(duration)
    local height = 100
    local winSize = cc.Director:getInstance():getWinSize()
    local up = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), winSize.width, height)
    g_BattleRoot:addChild(up, 1000)
    up:setPosition(0, winSize.height)
    up:runAction(cc.EaseOut:create(cc.MoveBy:create(duration, cc.p(0, -height)), 0.5))

    local down = cc.LayerColor:create(cc.c4b(0, 0, 0, 255), winSize.width, height)
    g_BattleRoot:addChild(down, 1000)
    down:setPosition(0, -height)
    down:runAction(cc.EaseOut:create(cc.MoveBy:create(duration, cc.p(0, height)), 0.5))
    --down:runAction(cc.MoveBy:create(duration, cc.p(0, height)))
end

function SPlayStory:playerSpeak(monster, str)
    monster:speak(str)
    if str == nil then return end
    self.mCoroutine:waitForSeconds(SPEAKER_DURATION)
end

return SPlayStory