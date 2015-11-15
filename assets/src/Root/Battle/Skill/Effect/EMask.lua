----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2015-4-28
-- 描述：遮罩
----------------------------------------------------------------------

local EMask = class("EMask", function () return cc.Layer:create() end)

function EMask.create(args)
    local ret = EMask.new()
    g_BattleRoot:addChild(ret, 100)
    ret:init(args)
    ret:setPosition(0, 0)
    return ret
end

function changeParent(root, child)
    child:retain()
    child:removeFromParent(false)
    root:addChild(child)
    child:release()
end

function EMask:init(args)
    local mask = cc.LayerColor:create(cc.c3b(0, 0, 0))
    mask:setOpacity(192)
    self:addChild(mask)
    self.mMask = mask

    Root:findRoot("EffectRootMgr"):modify(self)

    startCoroutine(self, "implPlay", args)
end

function EMask:implPlay(co, args)
    for _, monster in pairs(args.monsters) do
        local node = monster:getChild("ActionSprite")
        changeParent(self.mMask, node)
    end
    local duration = 1.5
    co:waitForSeconds(duration)

    for _, monster in pairs(args.monsters) do
        local node = monster:getChild("ActionSprite")
        changeParent(g_MonsterRoot, node)
    end

    local children = g_FrontEffectRoot:getChildren()
    for _, child in pairs(children) do
        changeParent(g_MonsterRoot, child)
    end
    Root:findRoot("EffectRootMgr"):recove()
    self:removeFromParent(true)
end

return EMask