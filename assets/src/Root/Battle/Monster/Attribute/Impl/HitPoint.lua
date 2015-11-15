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

function HitPoint:bearDamage(damage)
    local value = damage:getDamage()
    self:getBrother("DamageTips"):play(value)
    self:getBrother("ActionSprite").mModel:onHit()
end

return HitPoint
