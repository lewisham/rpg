----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：行动头像
----------------------------------------------------------------------

local UIChatPanel = NodeDef("UIChatPanel", "Layout/Monster/Speaker.csb")

function UIChatPanel:init()
    self:onCreate()
    Common.setClass(self, Child)
    local root = self:getBrother("ActionSprite")
    root:addChild(self)
    self:setPosition(0, 160)
    --self.text:enableOutline(cc.c4b(0, 0, 0, 255), 1.0)
end

function UIChatPanel:changeDir(dir)
    if dir == 1 then
        self:setPosition(40, 150)
        self.bg:setFlippedX(false)
        self.text:setPosition(30, -8)
    else
        self:setPosition(-40, 150)
        self.bg:setFlippedX(true)
        self.text:setPosition(-250, -8)
    end
end

function UIChatPanel:speak(dir, str)
    if str == nil then
        self:setVisible(false)
        return
    end
    self:changeDir(dir)
    self:setVisible(true)
    self.text:setString(str)
end

return UIChatPanel
