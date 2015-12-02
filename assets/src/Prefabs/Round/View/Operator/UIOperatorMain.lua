----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动列表视图
----------------------------------------------------------------------


local UIOperatorMain = NodeDef("UIOperatorMain", "Layout/Operator/OperatorMain.csb")

function UIOperatorMain:init()
    self:onCreate()
    g_RootScene:addChild(self, 1)
    self:setVisible(false)
end


return UIOperatorMain
