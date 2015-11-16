----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动头像
----------------------------------------------------------------------


local NodeActor = NodeDef("NodeActor", "Layout/Actors/ActorIconUp.csb")

function NodeActor.changeFile(group)
    if group == 1 then
        NodeActor._uiFileName = "Layout/Actors/ActorIconUp.csb"
    else
        NodeActor._uiFileName = "Layout/Actors/ActorIconDown.csb"
    end
end

function NodeActor:init(filename)
    self.icon:loadTexture(filename)
end

return NodeActor
