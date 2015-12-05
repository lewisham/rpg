----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动列表视图
----------------------------------------------------------------------


local UIActorsProgress = NodeDef("UIActorsProgress", "Layout/Actors/ActorsProgress.csb")

function UIActorsProgress:init()
    self:onCreate()
    self.mActors = {}
    self.mMaxLength = self.bar:getContentSize().width * self.bar:getScaleX() - 5
end

function UIActorsProgress:addActor(actor)
    local cls = require("Prefabs.Round.View.Actors.NodeActor")
    local group = actor:findComponent("GroupID")
    cls.changeFile(group)
    local root
    if group == 1 then
        root = self.up_root
    else
        root = self.down_root
    end
    local node = cls.new()
    node:init("hero_icon/"..actor._args.config.model.actor_icon)
    root:addChild(node)
    node:setScale(0.8)

    local unit = {}
    unit.node = node
    unit.actor = actor
    table.insert(self.mActors, unit)
end

function UIActorsProgress:updateAll()
    for _, val in pairs(self.mActors) do
        local bVisible = val.actor:findComponent("HitPoint"):isAlive()
        local percent = val.actor:findComponent("ActionBar"):getPercent()
        local x = math.floor(self.mMaxLength * percent / 100)
        val.node:setPositionX(x)
        val.node:setVisible(bVisible)
    end
end

function UIActorsProgress:updateWithTime(time)
    local duration = time * 2
    for _, val in pairs(self.mActors) do
        if val.actor:findComponent("HitPoint"):isAlive() then
            local percent = val.actor:findComponent("ActionBar"):getMovePercent()
            local x = math.floor(self.mMaxLength  * percent / 100)
            val.node:runAction(cc.MoveBy:create(duration, cc.p(x, 0)))
            val.node:setVisible(true)
        end
    end
    return duration
end

return UIActorsProgress
