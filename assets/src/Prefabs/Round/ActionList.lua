----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动列表
----------------------------------------------------------------------

local ActionList = class("ActionList", GameObject)

ActionList.ROOT_PATH = "Prefabs.Round"

function ActionList:init()
    g_ActionList = self
    self.mActors = {}
    self.mActionCnt = 0
    self.mBattleEndType = 0
    self:createComponent("View.Actors.UIActorsProgress")
    --self:createComponent("View.Operator.UIOperatorMain")
    startCoroutine(self, "update")
end

function ActionList:getActors()
    return self.mActors
end

function ActionList:removeFromScene()
    self:findComponent("UIActorsProgress"):removeFromParent(true)
    --self:findComponent("UIOperatorMain"):removeFromParent(true)
    self:release()
end

function ActionList:addActor(actor)
    table.insert(self.mActors, actor)
    self:findComponent("UIActorsProgress"):addActor(actor)
end

-- 获得空的位置
function ActionList:getEmptyPlace(group)
    local list = {1, 2, 3, 4, 5}
    for _, val in pairs(self.mActors) do
        if val:findComponent("GroupID") == group then
            local idx = val:findComponent("FIdx")
            list[idx] = nil
        end
    end
    return list
end

function ActionList:update(co)
    co:waitForSeconds(0.5)
    for _, val in pairs(self.mActors) do
        --val:findComponent("MStatusBar"):setVisible(true)
        val:findComponent("ActionSprite"):changeState("idle")
    end
    while true do
        local actor = self:calcNextActor(co)
        self:move(actor)
        co:waitForFuncResult(function() return self:isActionEnd() end)
        actor:findComponent("ActionBar"):empty()
        self:knockOutJudge(co)
        self:findComponent("UIActorsProgress"):updateAll()
        self:implBattleEndJudge(co)
        if self:isBattleEnd() then
            break
        end
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
        self:findComponent("UIActorsProgress"):updateAll()
    end
    return actor
end

-- 更新行动者
function ActionList:calcActor()
   local actor = nil
   for _, val in pairs(self.mActors) do
        if val:findComponent("HitPoint"):isAlive() and val:findComponent("ActionBar"):isFull() then
            actor = val
            break
        end
   end
   return actor
end

function ActionList:updateActorActionBar()
     for _, val in pairs(self.mActors) do
        if val:findComponent("HitPoint"):isAlive() then
            val:findComponent("ActionBar"):updatePerFrame()
        end
   end
end

----------------------------
-- 行动
----------------------------

function ActionList:move(actor)
    self:iActorStart(actor)
    self:getScene():createGameObject("Prefabs.Round.Round", actor)
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
        if val:findComponent("HitPoint"):isAlive() and val:findComponent("HitPoint"):isKnockout() then
            val:onKnockout()
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
        local idx = val:findComponent("GroupID")
        list[idx] = list[idx] + 1
        if not val:findComponent("HitPoint"):isAlive() then
            list[idx] = list[idx] - 1
        end
    end
    if list[1] == 0 then
        self.mBattleEndType = 1
    elseif list[2] == 0 then
        self.mBattleEndType = 2
    end
end

-- 更新列表，移除空指针
function ActionList:updateList()
    local bBreak = true
    while true do
        bBreak = true
        for key, val in pairs(self.mActors) do
            if val:getSelf() == nil then
                table.remove(self.mActors, key)
                bBreak = false
                break
            end
        end
        if bBreak then
            break
        end
    end
end

function ActionList:battleEnd()
    self:updateList()
    for _, val in pairs(self.mActors) do
        val:findComponent("MStatusBar"):setVisible(false)
        if val:findComponent("Phantasm") then
            val:removeFromScene()
        end
    end
    self.mActors = {}
end

return ActionList
