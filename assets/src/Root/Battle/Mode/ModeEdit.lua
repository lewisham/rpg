----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：角色类
----------------------------------------------------------------------

local ModeEdit = class("ModeEdit", Root)

ModeEdit.ROOT_PATH = "Root.Mode.ModeEdit"


-- 初始化
function ModeEdit:init(args)
    self:createChild("Root.Battle.Round.Camp")
    self:createChild("Root.Battle.Round.ActionList")

    local root = cc.Layer:create()
	g_RootScene:addChild(root)
	root:setPosition(0, 0)
    g_BattleRoot = root

    self:createChild("Root.Battle.Scene.BScene", {root = root})
    self:createChild("Root.Battle.Skill.Effect.EffectRootMgr")
    --local m1 = self:createMonster(101, cc.p(180, 256), 1)
    --Root:findRoot("ActionList"):addActor(m1)
	local m3 = self:createMonster(103, cc.p(140, 356), 1)
    Root:findRoot("ActionList"):addActor(m3)
    local m2 = self:createMonster(103, cc.p(1024 - 180, 256), 2)
	Root:findRoot("ActionList"):addActor(m2)
	--local m4 = self:createMonster(101, cc.p(1024 - 140, 356), 2)
	--Root:findRoot("ActionList"):addActor(m4)
    --m2:getChild("ActionSprite").mModel:loopPlay()
    

    local function playEffect(name, pos)
        local effect = require("Root.Battle.Skill.Effect.Effect").create(name, args)
        root:addChild(effect)
        effect:loopPlay()
        effect:setPosition(pos)
    end
    --playEffect("Zhujiao_feng_effect", cc.p(512, 100))
    --playEffect("pangde", cc.p(512, 100))
    --playEffect("simayi", cc.p(512, 100))
    --playEffect("shoujitexiao", cc.p(512, 100))
    --playEffect("fx_bullet_0005", cc.p(512, 300))

    local tb = {}
    tb.idx = 0
    local function touchEvent(sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        m2:getChild("ActionSprite").mModel:loopPlay(tb)
    end    
    local function createButton(idx)
        local button = ccui.Button:create()
        button:setTouchEnabled(true)
        button:loadTextures("test_1.png", "test_1.png", "")
        button:setPosition(cc.p(512 - 150 + 100 * (idx - 1), 60))        
        button:addTouchEventListener(touchEvent)
        button:setTag(idx)
        root:addChild(button)
    end
    createButton(5)
end

function ModeEdit:createMonster(id, pos, group)
    local config = monster_config[id]
    local path = "Root.Battle.Monster.Monster"
    local m1 = self:createChild(path, {config = config, position = pos, group = group})
    Root:findRoot("Camp"):addActor(m1)
    return m1
end


return ModeEdit