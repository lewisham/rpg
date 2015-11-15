----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能逻辑接口
----------------------------------------------------------------------

local SKLogic = class("SKLogic", SKBase)
_G["SKLogic"] = SKLogic

-- 计算伤害
function SKLogic:calcDamage(calcType)
    local damage = require("Root.Battle.Skill.Selector.Damage").create(self.mMonster, self.mTarget)
    damage:play(calcType, {percent = 100})
    return damage
end

-- 计算目标
function SKLogic:calcTargets(id)
    self.mTargetList = {self.mTarget}
end

-- 造成伤害
function SKLogic:makeDamage(calcType)
    for _, target in pairs(self.mTargetList) do
        target:getChild("HitPoint"):bearDamage(self:calcDamage(calcType))
    end
end

-- 生成buff
function SKBase:logicBuff(id, duration, args)

end



return SKLogic