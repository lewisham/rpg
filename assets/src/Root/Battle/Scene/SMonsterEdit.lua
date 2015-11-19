----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：角色类
----------------------------------------------------------------------

local SMonsterEdit = class("SMonsterEdit", Root)

SMonsterEdit.ROOT_PATH = "Root.Mode.SMonsterEdit"


-- 初始化
function SMonsterEdit:init(args)
    self:createChild("Root.Battle.Round.Camp")
    self:createChild("Root.Battle.UI.UIScene")
    self:createChild("Root.Battle.Round.ActionList")
    self:getChild("UIScene"):cameraMoveTo(0, 0.1)
    self:playLoopModel(10002)
    --self:playEffect("xiahoudun", cc.p(512, 100))

    self:addPlayMonster(10002, 1, 1)
    self:addPlayMonster(10001, 4, 2)
   
    
end

function SMonsterEdit:addPlayMonster(id, idx, group)
    local pos = calcFormantionPos(idx, group)
    local ret = createMonster(id, pos, group, idx)
    Root:findRoot("ActionList"):addActor(ret)
end

function SMonsterEdit:playLoopModel(id)
    local tb = {}
    tb.idx = 0
    local monster = createMonster(id, cc.p(512, 300), 0)
    local function touchEvent(sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        --monster:getChild("MState"):play(Monster_State.JiTui)
        monster:getChild("ActionSprite").mModel:loopPlay(tb)
    end    
    local button = ccui.Button:create()
    button:setTouchEnabled(true)
    button:loadTextures("test_1.png", "test_1.png", "")
    button:setPosition(cc.p(512 - 150 + 100 * (5 - 1), 60))        
    button:addTouchEventListener(touchEvent)
    g_BattleRoot:addChild(button)
end

function SMonsterEdit:playEffect(name, pos)
    local effect = require("Root.Battle.Skill.Effect.Effect").create(name, args)
    g_BattleRoot:addChild(effect)
    effect:loopPlay()
    effect:setPosition(pos)
end


return SMonsterEdit