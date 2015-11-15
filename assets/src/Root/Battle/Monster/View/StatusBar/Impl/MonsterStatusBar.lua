----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：角色状态栏(普通)
----------------------------------------------------------------------

local MonsterStatusBar = class("MonsterStatusBar", Child)

-- 构造
function MonsterStatusBar:ctor()
    MonsterStatusBar.super.ctor(self)
	self.mNode = nil
end

-- 初始化
function MonsterStatusBar:init()
	local filename = "UI/Battle/MonsterStatusBar/UIMonsterStatusBar.csb"
	-- 加入到父结点
	local parent = self:getBrother("MonsterViewHelper"):getDisplayNode("status_bar")
	local node = cc.CSLoader:createNode(filename)
	parent:addChild(node)
	self.mNode = node
	node:setPosition(-57, -13)
	
	self:createBar("LifeBar", {root = node, bReverse = false, bShake = false})    
	self:createBar("SpeedBar", {root = node})
	self:createBar("TargetArrow", {root = node})
	self:createBar("StyleIcon", {root = node})
end

-- 创建子结点
function MonsterStatusBar:createBar(path, args)
	self:createBrother("View.StatusBar.Impl.Component."..path, args)
end

function MonsterStatusBar:setVisible(bShow)
	self.mNode:setVisible(bShow)
end

return MonsterStatusBar
