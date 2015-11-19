----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏开场CG
----------------------------------------------------------------------

local SOpeningCG = class("SOpeningCG", Root)

-- 初始化
function SOpeningCG:init(args)
    startCoroutine(self, "play")
end

-- 开始执行逻辑
function SOpeningCG:play(co)
    self.mCoroutine = co
    self:createChild("Root.Battle.UI.UILoading", {10001, 10002})
    co:waitForFuncResult(function() return self:getChild("UILoading"):isDone() end)
    self:removeChild("UILoading")
    self:createChild("Root.Battle.UI.UIFStory"):play(co)
    self:createChild("Root.Battle.Round.Camp")
    self:createChild("Root.Battle.UI.UIScene")
    self:removeChild("UIFStory")
    self:createChild("Root.Battle.UI.UIPlaceName", "云梦岭郊外")
    co:waitForSeconds(2.5)
    local m1 = createMonster(10001, cc.p(-200, 256), 2, 1)
    m1:getChild("ActionSprite"):onSword(true)
    m1:getChild("ActionSprite"):onDir(1)
    co:waitForMonsterMoveTo(m1, calcFormantionPos(1, 2), 1.8, "cast")
    m1:getChild("ActionSprite"):onSword(false)
    m1:getChild("ActionSprite"):onDir(-1)

    local m2 = createMonster(10002, cc.p(-200, 256), 1, 1)
    m2:getChild("ActionSprite"):onSword(true)
    co:waitForMonsterMoveTo(m2, calcFormantionPos(1, 1), 0.8, "idle")
    m2:getChild("ActionSprite"):onSword(false)
    m2:getChild("ActionSprite"):changeState("cast")

    self:cameraMoveTo(0, 0.5)
    -- 片段2
    self:createChild("Root.Battle.UI.UISideMask", 0.6)
    co:waitForSeconds(0.6 + 0.8)
    self:playerSpeak(m1,"你为什么要背叛这些年来对你最亲近的人。")
    self:playerSpeak(m1,"难道只是为了那微不足道的金钱。")
    self:playerSpeak(m1,"让你可以在这里为所欲为。")
    self:playerSpeak(m2, "我别无选择，也没有退路。")
    self:playerSpeak(m2, "仇恨就像天边的浮云！")
    self:playerSpeak(m2, "或许有一天你会明白我为什么要这么做。")
    self:playerSpeak(m1, "这就是你的理由？")
    self:playerSpeak(m1, "或许是你太软弱，而不敢说不。")
    self:playerSpeak(m1, "即使是这时，你还是不敢出真像。")
    self:removeChild("UISideMask", 0.4)
    co:waitForSeconds(0.4 + 0.3)
    -- 开始战斗
    self:createChild("Root.Battle.Round.ActionList")
    Root:findRoot("ActionList"):addActor(m1)
    Root:findRoot("ActionList"):addActor(m2)
    co:waitForFuncResult(function() return self:getChild("ActionList"):isBattleEnd() end)
    self:playerSpeak(m1, "你居然解锁了上古巨魔之力。")
    self:playerSpeak(m2, "你果然比我想像的的要强。不过还是差了点。")
    self:playerSpeak(m2, "人为财死，鸟为食亡。")
    self:playerSpeak(m2, "这边是荒郊野岭，我就留你一口气，慢慢等死吧。")
    m2:getChild("ActionSprite"):onSword(true)
    m2:getChild("ActionSprite"):onDir(-1)
    co:waitForSeconds(0.5)
    co:waitForMonsterMoveTo(m2, cc.p(-300, 256), 0.8, "cast")
    self:playerSpeak(m1, "没想到我戎马一生，今日要葬身于此荒野。")

    self:cameraMoveTo(-1, 0.8)

    local m3 = createMonster(10003, cc.p(-200, 356), 1, 4)
    co:waitForMonsterMoveTo(m3, calcFormantionPos(5, 1), 1.8, "move")
    local m4 = createMonster(10003, cc.p(-200, 156), 1, 5)
    co:waitForMonsterMoveTo(m4, calcFormantionPos(4, 1), 1.8, "move")
    self:cameraMoveTo(0, 0.8)
    self:playerSpeak(m1, "糟糕，有狼群，可我走不动。")
    self:playerSpeak(m3, "delicious!")
    self:playerSpeak(m4, "yes!")
    --self:playerSpeak(m1, "没想到我戎马一生，今日要葬身于此荒野。")

end

local SPEAKER_DURATION = 0.9
-- 角色说话
function SOpeningCG:playerSpeak(monster, str)
    monster:speak(str)
    if str == nil then return end
    self.mCoroutine:waitForSeconds(SPEAKER_DURATION)
    monster:speak(nil)
end

function SOpeningCG:cameraMoveTo(posType, duration)
    self:getChild("UIScene"):cameraMoveTo(posType, duration)
    self.mCoroutine:waitForSeconds(duration)
end

return SOpeningCG