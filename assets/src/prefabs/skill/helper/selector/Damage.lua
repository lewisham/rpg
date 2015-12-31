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
    self.mValue = 1
    self.mAmplifyList = {} -- 加成列表
end

function Damage:init()
end

function Damage:addAmplify(amp)
    table.insert(self.mAmplifyList, amp)
end

function Damage:getDamage()
    return self.mValue
end

function Damage:getFinal()
    local total = self.mValue
    for _, val in pairs(self.mAmplifyList) do
        total = total + val
    end
    --print(self.mValue)
    --Log(self.mAmplifyList)
    return total
end

function Damage:reset(value)
    self.mValue = value
end

function Damage:play(calcType, args)
    local func = self["calc"..calcType]
    func(self, args)
end

function Damage:getCaster()
    return self.mCaster
end

function Damage:getTarget()
    return self.mTarget
end

---------------------------------------------
-- 伤害计算
---------------------------------------------

-- 伤害基于攻击力
function Damage:calc1(args)
    local atk = self.mCaster:findComponent("Atk"):getCurrent()
    self.mValue = -math.floor(PseudoRandom.random(90, 110) / 100 * atk)
end

-- 基于自身生命上限
function Damage:calc2(percent)
    local max = self.mCaster:findComponent("HitPoint"):getMax()
    self.mValue = -math.floor(percent / 100 * max)
end

return Damage
