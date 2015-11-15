----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能基类
----------------------------------------------------------------------

local SKBase = class("SKBase", Child)
_G["SKBase"] = SKBase

SKBase.ROOT_PATH = "Root.Battle.SKBase"

-- 构造函数
function SKBase:ctor()
    SKBase.super.ctor(self)
    self.mSkillInfos = {}
    self.mMonster = nil
    self.mTarget = nil
end

-- 初始化
function SKBase:init(args)
    self.mMonster = args.monster
    self:initDisplayRes()
    self:initLogic()
    self:initDisplay()

    for i = 1, 5 do
        local func = self["initSkill"..i]
        if func then
            func(self)
        end
    end
end

-- 添加技能
function SKBase:addSkillInfo(id, cd)
    local unit = {}
    unit.id = id
    unit.cd = cd or 0
    table.insert(self.mSkillInfos, unit)
end

-- 设置资源引用
function SKBase:initDisplayRes()
end

-- 初始化逻辑
function SKBase:initLogic()
end

-- 初始化表现
function SKBase:initDisplay()
end

-- 开启协程
function SKBase:startCoroutine(name, args)
    local cls = require("Root.Battle.Skill.SkillCoroutine")
    return cls.startCoroutine(self, name, args)
end

function SKBase:getSkillInfo()
    return self.mSkillInfos
end

function SKBase:play(idx, target)
    self.mTarget = target
    local logicCO = self:startCoroutine("excuteLogic"..idx)
    self.mDisplayCO = self:startCoroutine("playDisplay"..idx, logicCO)
end

function SKBase:over()
    Root:findRoot("ActionList"):iActorDone()
end

return SKBase
