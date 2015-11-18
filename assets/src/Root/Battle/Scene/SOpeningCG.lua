----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：游戏开场CG
----------------------------------------------------------------------

local SOpeningCG = class("SOpeningCG", Root)

-- 初始化
function SOpeningCG:init(args)
    --createObject("Root.Battle.UI.UIFStory")
    startCoroutine(self, "play")

    --[[
    local sprite = cc.Sprite:create("sunshangxiang.png")
    g_RootScene:addChild(sprite, 1)
    sprite:setPosition(512, 276)

    local glprogram = cc.GLProgram:createWithFilenames("common.vsh", "out_line.fsh")
	local state = cc.GLProgramState:getOrCreateWithGLProgram(glprogram)
	sprite:setGLProgramState(state)

	local size = sprite:getContentSize()
	state:setUniformVec2("resolution", cc.p(size.width, size.height))
	state:setUniformVec3("u_color", cc.vec3(1.0,0.6,0.0))
    ]]--

end

local SPEAKER_DURATION = 2.0

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
    co:waitForMonsterMoveTo(m1, calcFormantionPos(1, 2), 0.3, "moveback")
    local m2 = createMonster(10002, cc.p(-200, 256), 1, 1)
    co:waitForMonsterMoveTo(m2, calcFormantionPos(1, 1), 0.1)
    m2:getChild("ActionSprite"):changeState("cast")

    self:createChild("Root.Battle.UI.UISideMask", 0.6)
    co:waitForSeconds(0.6 + 0.8)
    self:playerSpeak(m1,"你为什么要背叛这些年来对你最亲近的人。")
    self:playerSpeak(m1,"难道只是为了那微不足道的金钱。")
    self:playerSpeak(m1,"让你可以在这里为所欲为。")
    self:playerSpeak(m1)
    self:playerSpeak(m2, "我别无选择，也没有退路。")
    self:playerSpeak(m2, "仇恨就像天边的浮云！")
    self:playerSpeak(m2, "或许有一天你会明白我为什么要这么做。")
    self:playerSpeak(m2)
    self:playerSpeak(m1, "这就是你的理由？")
    self:playerSpeak(m1, "或许是你太软弱，而不敢说不。")
    self:playerSpeak(m1, "即使是这时，你还是不敢出真像。")
    m1:removeChild("UIChatPanel")
    m2:removeChild("UIChatPanel")

    self:removeChild("UISideMask", 0.4)
    co:waitForSeconds(0.4 + 0.3)
    -- 开始战斗
    self:createChild("Root.Battle.Round.ActionList")
    Root:findRoot("ActionList"):addActor(m1)
    Root:findRoot("ActionList"):addActor(m2)
    co:waitForFuncResult(function() return self:getChild("ActionList"):isBattleEnd() end)
end

-- 角色说话
function SOpeningCG:playerSpeak(monster, str)
    monster:speak(str)
    if str == nil then return end
    self.mCoroutine:waitForSeconds(SPEAKER_DURATION)
end

return SOpeningCG