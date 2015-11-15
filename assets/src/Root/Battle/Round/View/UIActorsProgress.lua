----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动列表视图
----------------------------------------------------------------------


local UIActorsProgress = UIDef("UIActorsProgress", "Layout/Actors/ActorsProgress.csb")

function UIActorsProgress:onCreate()
    g_RootScene:addChild(self, 1)
    self.mActors = {}
    self.mMaxLength = self.bg:getContentSize().width * self.bg:getScaleX()
end

function UIActorsProgress:addActor(actor)
    local cls = require("Root.Battle.Round.View.NodeActor")
    local group = actor:getChild("GroupID")
    cls.changeFile(group)
    local root
    if group == 1 then
        root = self.up_root
    else
        root = self.down_root
    end
    local node = cls:create("hero_icon/"..actor._args.config.actor_icon)
    root:addChild(node)

    local unit = {}
    unit.node = node
    unit.actor = actor
    table.insert(self.mActors, unit)
end

function UIActorsProgress:updateAll()
    for _, val in pairs(self.mActors) do
        local precent = val.actor:getChild("ActionBar"):getPrecent()
        local x = math.floor(self.mMaxLength * precent / 100)
        val.node:setPositionX(x)
    end
end

return UIActorsProgress
