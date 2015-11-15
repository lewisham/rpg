----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：弹道
----------------------------------------------------------------------

local Missile = class("Missile", require("Root.Battle.Skill.Effect.Effect"))

function Missile.create(name, dir)
    dir = dir or 1
    local path = "Effect/"..name..".ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
    local ret = Missile.new(name)
    ret:init()
    ret:initDirection(dir)
    return ret
end


function Missile:moveTo(pos, duration, handler)
    local function callback()
        handler()
        self:removeFromParent(true)
    end
    local tb = 
    {
        cc.MoveTo:create(duration, pos),
        cc.CallFunc:create(callback, {}),
    }
    self:runAction(cc.Sequence:create(tb))
end

return Missile


