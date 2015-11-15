----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：场景
----------------------------------------------------------------------

local BScene = class("BScene", Root)

BScene.ROOT_PATH = "Root.Battle.Scene"

-- 构造函数
function BScene:ctor()
    BScene.super.ctor(self)
end

-- 初始化
function BScene:init(config)
	self:createComponent("View.BSceneViewHelper", config)
end

return BScene
