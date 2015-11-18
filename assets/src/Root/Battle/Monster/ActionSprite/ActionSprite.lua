----------------------------------------------------------------------
-- ���ߣ�lewis
-- ���ڣ�2015-4-28
-- ��������������
----------------------------------------------------------------------

local ActionSprite = class("ActionSprite", function() return cc.Layer:create() end)

-- ����
function ActionSprite:ctor()
    Common.setClass(self, Child)
    self.mModel = nil
    self.mOrginPosition = nil
    self.mExtraZOrder = 0
end

-- ��ʼ��
function ActionSprite:init(args)
    g_MonsterRoot:addChild(self)
    self:setOrginPosition(args.position)
    local config = args.config.model
    local dir = config.dir
	if args.group == 2 then dir = -dir end
    local name = config.model
    
    local scale = config.scale or 1.0
    local node = cc.Node:create()
    self:addChild(node)
    node:setAnchorPoint(0, 0)
    node:setScale(scale)

	local path = "monster/"..name.."/"..name..".ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
	local cls = require("Root.Battle.Monster.ActionSprite.Model.Model")
	local model = cls.create(name)
	model:init()
	model:initDirection(dir)
	node:addChild(model)
    self.mModel = model
    self.mDir = dir
end

-- ����վ��ԭʼλ��
function ActionSprite:setOrginPosition(pos)
    self.mOrginPosition = cc.p(pos.x, pos.y)
    self:setPosition(pos)
end

function ActionSprite:getOrginPosition()
    return cc.p(self.mOrginPosition.x, self.mOrginPosition.y)
end

-- ���ö���Ĳ㼶�ӳ�
function ActionSprite:setExtraZOrder(extra)
    self.mExtraZOrder = extra
end

-- ��������zorder
function ActionSprite:onOrder()
    local z = 800 - math.floor(self:getPositionY()) + self.mExtraZOrder
    self:setLocalZOrder(z)
end

function ActionSprite:changeState(name)
    self.mModel:playAnimate(name, 1)
end

return ActionSprite