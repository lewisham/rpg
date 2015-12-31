----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：恢复
----------------------------------------------------------------------

local Health = class("Health")

function Health.create(caster, target)
    local ret = Health.new()
    ret.mCaster = caster
    ret.mTarget = target
    ret.mCalcType = calcType
    ret:init()
    return ret
end

function Health:ctor()
    self.mCaster = nil
    self.mTarget = nil
    self.mValue = 1
    self.mAmplifyList = {} -- 加成列表
end

function Health:init()
end

function Health:play(calcType, args)
    local func = self["calc"..calcType]
    func(self, args)
end

function Health:getFinal()
    local total = self.mValue
    return total
end

---------------------------------------------
-- 恢复计算
---------------------------------------------

-- 基于攻击力
function Health:calc1(args)
    local atk = self.mCaster:findComponent("Atk"):getCurrent()
    self.mValue = math.floor(PseudoRandom.random(90, 110) / 100 * atk)
end

-- 基于自身生命上限
function Health:calc2(percent)
    local max = self.mCaster:findComponent("HitPoint"):getMax()
    self.mValue = math.floor(percent / 100 * max)
end

return Health
