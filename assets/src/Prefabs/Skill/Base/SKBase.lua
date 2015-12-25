----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：技能基类
----------------------------------------------------------------------

SKBase = class("SKBase", Component)
_G["SKBase"] = SKBase

-- 构造函数
function SKBase:ctor()
    SKBase.super.ctor(self)
    self.mSkillInfos = {}   -- 技能信息表
    self.mMonster = nil     
    self.mTarget = nil
    self.mPlayingIdx = 0
end

-- 初始化
function SKBase:init(args)
    self.mMonster = args.monster
    self:initDisplayRes()
    self:initLogic()
    self:initDisplay()

    for _, val in pairs(self.mSkillInfos) do
        local func = self["initSkill"..val.id]
        if func then
            func(self)
        end
    end
end

-- 添加技能
function SKBase:addSkillInfo(id, cd, passive)
    local unit = {}
    unit.id = id
    unit.cur_cd = 0
    unit.max_cd = cd
    unit.passive = passive == nil and false or passive
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
    local cls = require("Prefabs.Skill.SkillCoroutine")
    return cls.startCoroutine(self, name, args)
end

function SKBase:getSkillInfo()
    local list = {}
    for _, val in pairs(self.mSkillInfos) do
        if val.cur_cd == 0 and not val.passive then
            table.insert(list, val)
        end
    end
    return list
end

function SKBase:play(co, idx, target)
    self.mRunningCount = 1
    self.mPlayingIdx = idx
    self.mTarget = target
    self:startCoolDown(idx)
    -- 开始表现
    local logicCO = self:startCoroutine("excuteLogic"..idx)
    self.mDisplayCO = self:startCoroutine("playDisplay"..idx, logicCO)
    co:waitForFuncResult(function() return self:isOver() end)
    self.mPlayingIdx = 0
end

function SKBase:isOver()
    return self.mRunningCount == 0
end

function SKBase:over()
    self.mRunningCount = self.mRunningCount - 1
end

-- 开启cd
function SKBase:startCoolDown(idx)
    local unit = nil
    for _, val in pairs(self.mSkillInfos) do
        if val.id == idx then
            unit = val
        elseif not val.passive and val.cur_cd > 0 then
            val.cur_cd = val.cur_cd - 1
        end
    end
    if unit == nil then return end
    unit.cur_cd = unit.max_cd
end

