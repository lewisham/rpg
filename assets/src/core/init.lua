require("Core.Coroutine")
require("Core.UIBase")
require("Core.RequireReload")
require("Core.u3d.GameScene")
require("Core.u3d.GameObject")
require("Core.u3d.Component")
require("Core.Log")

local mInstanceId = 0

function getInstanceId()
    mInstanceId = mInstanceId + 1
    return mInstanceId
end

