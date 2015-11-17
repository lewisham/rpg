----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动列表视图
----------------------------------------------------------------------


local UISkillSelector = NodeDef("UISkillSelector", "Layout/Skill/SkillSelector.csb")

function UISkillSelector:init()
    g_RootScene:addChild(self, 1)

    local function callback(idx) self:clickHandler(idx) end
    self.mIconList = {}
    for idx = 1, 4 do
        local node = require("Root.Battle.Round.View.NodeSkillIcon").new()
        node:init(idx, callback)
        self["node"..idx]:addChild(node)
        table.insert(self.mIconList, node)
    end
end

function UISkillSelector:onUse(co)
end

function UISkillSelector:clickHandler(idx)
    print(idx)
end

return UISkillSelector
