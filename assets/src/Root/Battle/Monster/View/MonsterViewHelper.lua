----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：视图helper
----------------------------------------------------------------------

local MonsterViewHelper = class("MonsterViewHelper", Child)

MonsterViewHelper.FOLDER = "View"

-- 构造
function MonsterViewHelper:ctor()
	MonsterViewHelper.super.ctor(self)
    self.mDisplayNodeList = {}
end

-- 初始化
function MonsterViewHelper:init(args)
	self:createActionSprite(args)
    self:createDisplayNode()
    self:createBrother("View.StatusBar.StatusBarHelper")
    self:createBrother("View.StatusTips.StatusTipsHelper")
end

function MonsterViewHelper:createActionSprite(args)
	local dir = 1
	if args.group == 2 then dir = -1 end
	local cls = require(self:getRelativePath()..".ActionSprite.ActionSprite")
	local ret = cls.create(args)
    g_MonsterRoot:addChild(ret)
	ret:init(args.config.model, dir)
	ret:setOrginPosition(args.position)
    self:getRoot():addChild("ActionSprite", ret)
end

-- 创建显示结点
function MonsterViewHelper:createDisplayNode()
	local names = {"status_bar", "damage", "status_tips", "skill_in_use_tips", "drop_out"}
	local sprite = self:getBrother("ActionSprite")
	for _, name in pairs(names) do
		local layer = cc.Layer:create()
		sprite:addChild(layer)
		self.mDisplayNodeList[name] = layer
	end

    self.mDisplayNodeList["status_bar"]:setPosition(0, 160)
    self.mDisplayNodeList["damage"]:setPosition(0, 190)
end

function MonsterViewHelper:getDisplayNode(name)
	return self.mDisplayNodeList[name]
end

return MonsterViewHelper