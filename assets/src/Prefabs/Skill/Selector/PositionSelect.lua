----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：位置选择
----------------------------------------------------------------------

local PositionSelect = class("PositionSelect")

function PositionSelect.create(skill)
    local ret = PositionSelect.new()
    ret.mSkill = skill
    return ret
end

function PositionSelect:play(id, args)
    local pos = nil
    local func = self["solution"..id]
    local pos = func(self, args)
    return pos
end

--　1敌方正前方
function PositionSelect:solution1(args)
    local monster = self.mSkill.mTarget
    local pos = cc.p(monster:findComponent("ActionSprite"):getPosition())
    local groupId = monster:findComponent("GroupID")
    local args = args or 0
    local offx = 160 + args
    if groupId == 2 then
        offx = -offx
    end
    pos.x = pos.x + offx
    return pos 
end

-- 2自己原始位置
function PositionSelect:solution2()
    return self.mSkill.mMonster:findComponent("ActionSprite"):getOrginPosition()
end

-- 3已方当前位置
function PositionSelect:solution3()
    return cc.p(self.mSkill.mMonster:findComponent("ActionSprite"):getPosition())
end

-- 4目标当前位置
function PositionSelect:solution4()
    return cc.p(self.mSkill.mTarget:findComponent("ActionSprite"):getPosition())
end

-- 已方阵型中心
function PositionSelect:solution5()
    local group = self.mSkill.mMonster:findComponent("GroupID")
    return self:getPositionByGroup(group)
end

-- 敌方阵型中心
function PositionSelect:solution6()
    local group = self.mSkill.mMonster:findComponent("GroupID")
    if group == 1 then
        group = 2
    else
        group = 1
    end
    return self:getPositionByGroup(group)
end

-- 战场正中心
function PositionSelect:solution7()
    return cc.p(SCENE_MAP_WIDTH / 2, SCENE_MAP_MIDDLE_Y)
end

function PositionSelect:getPositionByGroup(group)
    if group == 1 then
        return cc.p(SCENE_MAP_WIDTH / 2 - 256, SCENE_MAP_MIDDLE_Y)
    else
        return cc.p(SCENE_MAP_WIDTH / 2 + 256, SCENE_MAP_MIDDLE_Y)
    end
end

return PositionSelect