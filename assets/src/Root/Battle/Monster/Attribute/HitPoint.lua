----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：生命值
----------------------------------------------------------------------

local HitPoint = class("HitPoint", AttributeBase)

-- 构造
function HitPoint:ctor()
	HitPoint.super.ctor(self)
end

-- 初始化
function HitPoint:init(args)
    self:initConfig(args.hit_point, args.hit_point)
end

-- 是否存活
function HitPoint:isAlive()
    return self.mCurrent > 0
end

-- 是否阵亡
function HitPoint:isKnockout()
    return self.mCurrent <= 0
end

-- 受到伤害
function HitPoint:bearDamage(damage)
    local value = damage:getDamage()
    self.mCurrent = self.mCurrent + value
    if self:isKnockout() then
        self.mCurrent = self.mMax
    end
    self:getBrother("HPTips"):play(value)
    self:getBrother("ActionSprite").mModel:onHit()
    self:getBrother("LifeBar"):update(self:getPercent())
end

return HitPoint
