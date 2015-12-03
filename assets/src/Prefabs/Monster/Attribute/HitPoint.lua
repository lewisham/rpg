----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：生命值
----------------------------------------------------------------------

local HitPoint = class("HitPoint", AttributeBase)

-- 构造
function HitPoint:ctor()
	HitPoint.super.ctor(self)
    self.mbAlive = true
end

-- 初始化
function HitPoint:init(args)
    self:initConfig(args.hit_point, args.hit_point)
end

-- 是否存活
function HitPoint:isAlive()
    return self.mbAlive
end

-- 是否阵亡
function HitPoint:isKnockout()
    return self.mCurrent <= 0
end

-- 受到伤害
function HitPoint:bearDamage(damage)
    local value = damage:getDamage()
    self.mCurrent = self.mCurrent + value
    self:findComponent("HPTips"):play(value)
    self:findComponent("ActionSprite").mModel:onHit()
    self:findComponent("LifeBar"):update(self:getPercent())
end

function HitPoint:onKnockout()
    self.mbAlive = false
end

return HitPoint
