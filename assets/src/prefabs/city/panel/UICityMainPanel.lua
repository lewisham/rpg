----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：全屏剧情
----------------------------------------------------------------------

local UICityMainPanel = class("UICityMainPanel", UIBase)

UICityMainPanel._uiFileName = "City/CityMainPanel.csb"

function UICityMainPanel:init()
    self:onCreate()
end

return UICityMainPanel
