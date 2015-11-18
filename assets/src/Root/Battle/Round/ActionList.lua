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
    self.mbBattleEnd = false
    self:createComponent("View.Actors.UIActorsProgress")
    self:createComponent("View.Operator.UIOperatorMain")
    startCoroutine(self, "update")
end

function ActionList:addActor(actor)
    table.insert(self.mActors, actor)
    self:getChild("UIActorsProgress"):addActor(actor)
end

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
        self:move(actor)
        co:waitForFuncResult(function() return self:isActionEnd() end)
        actor:getChild("ActionBar"):empty()
        self:getChild("UIActorsProgress"):updateAll()
        co:waitForSeconds(1.0)
    end
    co:waitForSeconds(1.0)
    self:battleEnd()
end

-- 是否是战斗结束了
function ActionList:isBattleEnd()
    return self.mbBattleEnd
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

-- 行动
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

function ActionList:battleEnd()
end

return ActionList
