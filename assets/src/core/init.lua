require("core.Device")
require("core.Coroutine")
require("core.YieldType")
require("core.UIBase")
require("core.RequireReload")
require("core.u3d.GameScene")
require("core.u3d.GameObject")
require("core.u3d.Component")
require("core.Log")

local mInstanceId = 0

function getInstanceId()
    mInstanceId = mInstanceId + 1
    return mInstanceId
end

