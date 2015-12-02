----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：全屏剧情
----------------------------------------------------------------------

local UICityMainPanel = class("UICityMainPanel", GameObject)

function UICityMainPanel:init()
    self:loadCsb("City/CityMainPanel.csb")
end

return UICityMainPanel
