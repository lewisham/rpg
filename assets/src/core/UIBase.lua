----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：节点基类
----------------------------------------------------------------------

UIBase = class("UIBase", function() return ccui.Widget:create() end)

UIBase._uiFileName = ""

function UIBase:ctor()
    self.mDelegate = nil
end


function UIBase:onCreate(filename)
    filename = filename or self._uiFileName
	self:setAnchorPoint(0, 0)
    if filename == nil then return end
	local node = cc.CSLoader:createNode(filename)
 	self:setContentSize(node:getContentSize())
 	self:setTouchEnabled(false) -- 防止穿透
	for k, v in pairs(node:getChildren()) do
		v:changeParentNode(self)
	end
	self:_autoRegisterButtonsAndVars()
end

function UIBase:init()
end

function UIBase:removeFromScene()
    self:removeFromParent(true)
end

-- 自动注册按钮点击事件和控件名称
function UIBase:_autoRegisterButtonsAndVars()
	self:visitAll(function(child)
					local objName = child:getName()
					if (not objName) or objName == '' then
						return
					end
					self[objName] = child -- 保存直接引用关系
                    if self.mDelegate then self.mDelegate[objName] = child end
					-- 修复scale9控件bug
					if child.isScale9Enabled and not child:isScale9Enabled() then
						if tolua.type(child) ~= "ccui.Slider" then
							child:ignoreContentAdaptWithSize(true)
						end
					end

					if tolua.iskindof(child, 'ccui.Button') or tolua.iskindof(child, 'ccui.CheckBox') then
					 	child:onClicked(function()
					 						-- 事件名加click_前缀
					 						local eventName = 'click_' .. objName
                                            local target = self.mDelegate or self
					 						local fn = target[eventName]
					 						if fn then
					 							print('点击按钮'.. objName)
					 							fn(target, child)
					 						else
					 							print('缺少按钮事件代码 ' .. eventName)
					 						end
					 					end)
					 end
				end)
end

function NodeDef(clsname, filename)
    local ret = class(clsname, GameObject)
    ret._uiFileName = filename
    return ret
end


