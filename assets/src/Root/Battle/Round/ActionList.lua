----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动列表
----------------------------------------------------------------------

local ActionList = class("ActionList", Root)

ActionList.ROOT_PATH = "Root.Battle.Round"

function ActionList:init()
    self.mActors = {}
    self.mActionCnt = 0
    self.mBattleEndType = 0
    self:createComponent("View.Actors.UIActorsProgress")
    self:createComponent("View.Operator.UIOperatorMain")
    startCoroutine(self, "update")
end

function ActionList:addActor(actor)
    table.insert(self.mActors, actor)
    self:getChild("UIActorsProgress"):addActor(actor)
end

-- 获得空的位置
function ActionList:getEmptyPlace(group)
    local list = {1, 2, 3, 4, 5}
    for _, val in pairs(self.mActors) do
        if val:getChild("GroupID") == group then
            local idx = val:getChild("FIdx")
            list[idx] = nil
        end
    end
    return list
end

function ActionList:update(co)
    co:waitForSeconds(0.5)
    for _, val in pairs(self.mActors) do
        val:getChild("MStatusBar"):setVisible(true)
        val:getChild("ActionSprite"):changeState("idle")
    end
    while true do
        if self:isBattleEnd() then
            break
        end
        local actor = self:calcNextActor(co)
        self:move(actor)
        co:waitForFuncResult(function() return self:isActionEnd() end)
        actor:getChild("ActionBar"):empty()
        self:knockOutJudge(co)
        self:getChild("UIActorsProgress"):updateAll()
        self:implBattleEndJudge(co)
        co:waitForSeconds(1.0)
    end
    self:battleEnd()
end

----------------------------
-- 步骤1
----------------------------

-- 是否是战斗结束了
function ActionList:isBattleEnd()
    return self.mBattleEndType ~= 0
end

-- 计算下一个行动者
function ActionList:calcNextActor(co)
    self.mActionCnt = 0
    local actor = nil
    while true do
        actor = self:calcActor()
        if actor then
            break
        end
        co:waitForFrames(1)
        self:updateActorActionBar()
        self:getChild("UIActorsProgress"):updateAll()
    end
    return actor
end

-- 更新行动者
function ActionList:calcActor()
   local actor = nil
   for _, val in pairs(self.mActors) do
        if val:getChild("ActionBar"):isFull() then
            actor = val
            break
        end
   end
   return actor
end

function ActionList:updateActorActionBar()
     for _, val in pairs(self.mActors) do
        val:getChild("ActionBar"):updatePerFrame()
   end
end

----------------------------
-- 行动
----------------------------

function ActionList:move(actor)
    self:iActorStart(actor)
    self:createChild("Root.Battle.Round.Round", actor)
    --actor
end

-- 行动开始
function ActionList:iActorStart(actor)
    self.mActionCnt = self.mActionCnt + 1
end

-- 行动结束
function ActionList:iActorDone(actor)
    self.mActionCnt = self.mActionCnt - 1
end

function ActionList:isActionEnd()
    return self.mActionCnt <= 0
end

----------------------------
-- 死亡判定
----------------------------
function ActionList:knockOutJudge(co)
    local cnt = 0
    for _, val in pairs(self.mActors) do
        if val:getChild("HitPoint"):isAlive() and val:getChild("HitPoint"):isKnockout() then
            val:getChild("ActionSprite"):changeState("dead")
            val:getChild("HitPoint"):onKnockout()
            cnt = cnt + 1
        end
    end
    if cnt > 0 then
        co:waitForSeconds(0.5)
    end
end

----------------------------
-- 战斗结束判定
----------------------------
function ActionList:implBattleEndJudge(co)
    local list = {0, 0}
    for _, val in pairs(self.mActors) do
        local idx = val:getChild("GroupID")
        list[idx] = list[idx] + 1
        if not val:getChild("HitPoint"):isAlive() then
            list[idx] = list[idx] - 1
        end
    end
    if list[1] == 0 then
        self.mBattleEndType = 1
    elseif list[2] == 0 then
        self.mBattleEndType = 2
    end
end

function ActionList:battleEnd()
    for _, val in pairs(self.mActors) do
        val:getChild("MStatusBar"):setVisible(false)
        if val:getChild("Phantasm") then
            val:destroy()
        end
    end
    self.mActors = {}
    self:removeChild("UIActorsProgress")
end

return ActionList
