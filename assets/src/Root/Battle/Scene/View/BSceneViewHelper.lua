----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：视图helper
----------------------------------------------------------------------

local BSceneViewHelper = class("BSceneViewHelper", Child)

BSceneViewHelper.FOLDER = "View"

-- 构造
function BSceneViewHelper:ctor()
	BSceneViewHelper.super.ctor(self)
end

-- 初始化
function BSceneViewHelper:init(args)
	self:createScene(args)
end

function BSceneViewHelper:createScene(args)
    local name = "Scene/scene06/scene06_1.csb"
    local node = cc.CSLoader:createNode(name)
	args.root:addChild(node)
    g_MonsterRoot = node:getChildByName("ground")
end

return BSceneViewHelper
