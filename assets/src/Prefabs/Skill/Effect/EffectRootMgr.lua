----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：特效根结点管理
----------------------------------------------------------------------

g_FrontEffectRoot = nil
g_BackEffectRoot = nil

local EffectRootMgr = class("EffectRootMgr", Root)

function EffectRootMgr:init()
    self.front = cc.Layer:create()
    g_MonsterRoot:addChild(self.front , 1000)

    self.back = cc.Layer:create()
    g_MonsterRoot:addChild(self.back, 0)

    g_FrontEffectRoot = self.front
    g_BackEffectRoot = self.back
end

function EffectRootMgr:modify(root)
    g_FrontEffectRoot = cc.Layer:create()
    root:addChild(g_FrontEffectRoot , 1000)

    g_BackEffectRoot = cc.Layer:create()
    root:addChild(g_BackEffectRoot, 0)
end

function EffectRootMgr:recove()
    g_FrontEffectRoot = self.front
    g_BackEffectRoot = self.back
end

return EffectRootMgr

