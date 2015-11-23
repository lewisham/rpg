----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2015-4-28
-- 描述：动作精灵
----------------------------------------------------------------------

local ActionSprite = class("ActionSprite", function() return cc.Layer:create() end)

-- 构造
function ActionSprite:ctor()
    Common.setClass(self, Child)
    self.mNode = nil
    self.mModel = nil
    self.mOrginPosition = nil
    self.mExtraZOrder = 0
end

-- 初始化
function ActionSprite:init(args)
    g_MonsterRoot:addChild(self)
    self:setOrginPosition(args.position)
    local config = args.config.model
    local dir = config.dir
    self.mOrginDir = dir
	if args.group == 2 then dir = -dir end
    local name = config.model

    
    local scale = config.scale or 1.0
    local node = cc.Node:create()
    self:addChild(node)
    node:setAnchorPoint(0, 0)
    node:setScale(scale)
    self.mNode = node

	local path = "monster/"..name.."/"..name..".ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
	local cls = require("Root.Battle.Monster.ActionSprite.Model.Model")
	local model = cls.create(name)
	model:init()
	model:initDirection(dir)
	node:addChild(model, 1)
    self.mModel = model
    self.mDir = dir * self.mOrginDir
end

function ActionSprite:onDir(dir)
    self.mModel:initDirection(self.mOrginDir * dir)
    if self.mSword then
        self.mSword:setScale(dir)
    end
    self.mDir = dir * self.mOrginDir
end

-- 设置站立原始位置
function ActionSprite:setOrginPosition(pos)
    self.mOrginPosition = cc.p(pos.x, pos.y)
    self:setPosition(pos)
end

function ActionSprite:getOrginPosition()
    return cc.p(self.mOrginPosition.x, self.mOrginPosition.y)
end

-- 设置额外的层级加成
function ActionSprite:setExtraZOrder(extra)
    self.mExtraZOrder = extra
end

-- 重新设置zorder
function ActionSprite:onOrder()
    local z = 800 - math.floor(self:getPositionY()) + self.mExtraZOrder
    self:setLocalZOrder(z)
end

function ActionSprite:changeState(name, args)
    local func = self["state_"..name]
    func(self, args)
end

function ActionSprite:state_idle()
    self.mModel:playAnimate("idle", 1)
end

function ActionSprite:state_cast()
    self.mModel:playAnimate("cast", 1)
end

function ActionSprite:state_dead()
    self.mModel:playAnimate("dead", 0)
end

-- 御剑飞行
function ActionSprite:onSword(bOn)
    if bOn then
        local sword = require("Root.Battle.Monster.ActionSprite.FlySword").new()
        sword:init()
        self.mNode:addChild(sword)
        self.mNode:setPosition(0, 100)
        self.mSword = sword
    elseif self.mSword then
        --self.mNode:setPosition(0, 0)
        self.mSword:removeFromParent(true)
        self.mSword = nil
        self.mNode:runAction(cc.EaseIn:create(cc.MoveTo:create(0.3, cc.p(0, 0)), 1.5))
    end
end

-- 逃跑
function ActionSprite:escape(dir, callback)
    self:onDir(dir)
    self.mModel:playAnimate("move", 1)
    local pos = cc.p(self.mOrginPosition.x, self.mOrginPosition.y)
    pos.x = pos.x + dir * 680
    local tb = 
    {
        cc.MoveTo:create(1.0, pos),
        cc.CallFunc:create(callback, {})
    }
    self:runAction(cc.Sequence:create(tb))
end


return ActionSprite