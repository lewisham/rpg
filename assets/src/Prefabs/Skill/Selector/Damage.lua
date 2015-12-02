----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：伤害
----------------------------------------------------------------------

local Damage = class("Damage")

function Damage.create(caster, target)
    local ret = Damage.new()
    ret.mCaster = caster
    ret.mTarget = target
    ret.mCalcType = calcType
    ret:init()
    return ret
end

function Damage:ctor()
    self.mCaster = nil
    self.mTarget = nil
    self.mDamageValue = 1
end

function Damage:init()
end

function Damage:getDamage()
    return self.mDamageValue
end

function Damage:play(calcType, args)
    local func = self["calc"..calcType]
    func(self, args)
end

-- 伤害基于攻击力
function Damage:calc1(args)
    local atk = self.mCaster:getComponent("Atk"):getCurrent()
    self.mDamageValue = -math.floor(math.random(90, 110) / 100 * atk)
end


return Damage
