----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动头像
----------------------------------------------------------------------

local NodeActor = class("NodeActor", UIBase)

NodeActor._uiFileName = "Layout/Actors/ActorIconUp.csb"

function NodeActor:init(filename, group)
    local file
    if group == 1 then
        file = "Layout/Actors/ActorIconUp.csb"
    else
        file = "Layout/Actors/ActorIconDown.csb"
    end
    self.mbAutoAddTo = false
    self:onCreate(file)
    self.icon:loadTexture(filename)
    local width = self.icon:getContentSize().width
    local scale = self.icon:getScale()
    self.icon:setScale(83 / width * scale)
    --print(width, scale, self.icon:getScale())
end

return NodeActor
