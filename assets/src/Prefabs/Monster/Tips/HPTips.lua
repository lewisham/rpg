----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-4-4
-- 描述：生命值改变数字提示
----------------------------------------------------------------------

local HPTips = class("HPTips", Component)

local mStringList = {}
mStringList["vampirism"] 	= {"吸血", cc.c3b(0,255,0)}
mStringList["reflect"]		= {"伤害反弹", cc.c3b(255,0,0)}

-- 构造
function HPTips:ctor()
	HPTips.super.ctor(self)
	self.mDislayList = {}
	self.mCurPlayEffect = nil
end

function HPTips:init()
end

----------------------------------------------
-- 攻击伤害显示
----------------------------------------------

-- 显示效果
function HPTips:play(damage)
	table.insert(self.mDislayList, damage)
	self:flush()
end

-- 清空
function HPTips:flush()
	if self.mCurPlayEffect ~= nil then return end
	local damage = self.mDislayList[1]
	if damage == nil then return end
	self:playEffectMode_2(damage)
	table.remove(self.mDislayList, 1)
end

-- 数值显示模式二
function HPTips:playEffectMode_2(damage)
	local filename, str = self:getLabelParam(damage)
	
	-- 创建根结点
	local root = self:findComponent("ActionSprite")
	local layer = cc.Layer:create()
	root:addChild(layer)
    layer:setPosition(0, 180)
	
	
	local TOTAL_TIME = 0.7
	local holdTime = TOTAL_TIME * 0.4
	local function play(char, duration, x, height, delayTime)
		local label = cc.LabelAtlas:_create(char, filename, 25, 33, 43)
		layer:addChild(label, 1000)
		label:setPosition(x, -height)
		local moveTime = (duration - holdTime - delayTime) / 2
		local tb = 
		{
			cc.DelayTime:create(delayTime),
			cc.Show:create(),
			cc.Spawn:create(cc.MoveBy:create(moveTime, cc.p(0, height)), cc.FadeIn:create(moveTime)),
			cc.DelayTime:create(holdTime),
			cc.Spawn:create(cc.MoveBy:create(moveTime, cc.p(0, height)), cc.FadeOut:create(moveTime)),
		}
		label:runAction(cc.Sequence:create(tb))
		label:setVisible(false)
		label:setOpacity(0)
	end
	
	local x = 0
	local height = 30
	local duration = TOTAL_TIME
	local delay = 0
	local delayUnit = (duration - holdTime) / (2 * #str)
	for i = 1, #str do
		play(string.sub(str, i, i), duration, x, height, delay)
		height = height + 20
		x = x + 25
		delay = delay + delayUnit
	end
	duration = duration + delay
	
	
	local function callback()
		self.mCurPlayEffect = nil
		self:flush()
	end
	
	layer:setPositionX(-x / 2)
	local tb = 
	{
		cc.DelayTime:create(duration * 0.3),
		cc.CallFunc:create(callback, {}),
		cc.DelayTime:create(duration * 0.7),
		cc.RemoveSelf:create(),
		
	}
	self.mCurPlayEffect = layer
	layer:runAction(cc.Sequence:create(tb))
end

-- 获得显示参数
function HPTips:getLabelParam(damage)
	return "fonts/battle_num_damage.png", tostring(damage)
end

return HPTips