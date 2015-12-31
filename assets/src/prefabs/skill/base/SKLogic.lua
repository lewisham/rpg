----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能逻辑接口
----------------------------------------------------------------------

SKLogic = class("SKLogic", SKBase)

function SKLogic:initLogic()
    self:createSelector("InputTargetSelector")
    self:createSelector("TargetSelect")
end

function SKLogic:getInputTargets(idx)
    return self.InputTargetSelector:play(1)
end

-- 计算伤害
function SKLogic:calcDamage(calcType, target, args)
    local damage = CreateDamage(self.mMonster, target)
    damage:play(calcType, args)
    return damage
end

-- 计算恢复
function SKLogic:calcHealth(calcType, target, args)
    local health = CreateDamage(self.mMonster, target)
    health:play(calcType, args)
    return health
end

-- 计算目标
function SKLogic:calcTargets(id)
    id = id or 1
    self.mTargetList = self.TargetSelect:play(id)
end

-- 造成伤害
function SKLogic:makeDamage(calcType)
    for _, target in pairs(self.mTargetList) do
        local damage = self:calcDamage(calcType, target)
        SModifyHitPoint:getInstance():post(damage)
        target:findComponent("HitPoint"):modifyHitPoint(damage)
    end
end

-- 生成buff
function SKLogic:logicBuff(id, duration, args)

end

function SKLogic:playState(name)
    for _, target in pairs(self.mTargetList) do
        target:findComponent("MState"):play(name)
    end
end
