----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2015-4-28
-- 描述：动作精灵
----------------------------------------------------------------------

local ActionSprite = class("ActionSprite", function() return cc.Layer:create() end)

-- 构造
function ActionSprite:ctor()
    self.mModel = nil
    self.mOrginPosition = nil
end

-- 初始化
function ActionSprite:init(name, dir)
    local node = cc.Node:create()
    self:addChild(node)
    node:setAnchorPoint(0, 0)
    --node:setScale(0.95)

	local path = "monster/"..name.."/"..name..".ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
	local cls = require("Root.Battle.Monster.View.ActionSprite.Model.Model")
	local model = cls.create(name)
	model:init()
	model:initDirection(dir)
	node:addChild(model)
    self.mModel = model
end

function ActionSprite:setOrginPosition(pos)
    self.mOrginPosition = cc.p(pos.x, pos.y)
    self:setPosition(pos)
end

function ActionSprite:getOrginPosition()
    return cc.p(self.mOrginPosition.x, self.mOrginPosition.y)
end

function ActionSprite:actionMoveTo(pos, duration, callback)
    local tb = 
    {
        cc.MoveTo:create(duration, pos),
        cc.CallFunc:create(callback, {}),
    }
    self:runAction(cc.Sequence:create(tb))
end

function ActionSprite:changeState(name)
    self.mModel:playAnimate(name, 1)
end

return ActionSprite