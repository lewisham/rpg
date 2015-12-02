require("Core.Coroutine")
require("Core.UIBase")
require("Core.RequireReload")
require("Core.U3D.GameScene")
require("Core.U3D.GameObject")
require("Core.U3D.Component")
require("Core.Log")

local mInstanceId = 0

function getInstanceId()
    mInstanceId = mInstanceId + 1
    return mInstanceId
end

