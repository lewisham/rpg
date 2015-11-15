----------------------------------------------------------------------
-- 作者：hongjx
-- 描述：UI基类
----------------------------------------------------------------------
----------------------------------------------------------------------
-- 作者：hongjx
-- 描述：全局类声明(全局类的好处是可以运行时修改, 坏处是低效)
----------------------------------------------------------------------


----------------------------------------------------------------------
-- 功能：全局类声明(全局类的好处是可以运行时修改, 坏处是低效)
-- 参数className: 类名, 并作为全局变量使用
-- 参数baseClassName: 基类名, 可以为nil, 也可以为function
-- 返回值：nil
----------------------------------------------------------------------
function GClass(className, baseClassName)
	assert(type(className) == "string", "请提供类名, 并作为全局变量使用") -- 防止误传类名
	if baseClassName then
		assert(type(baseClassName) == "string" or type(baseClassName) == 'function', "基类名不合法") -- 防止误传基类
	end

	_G[className] = _G[className] or {} -- 支持类分布在多个文件中

	local cls = _G[className]

	cls._className = className
	cls._baseClassName = baseClassName

	cls.__index = function(_t, k)
							local myClass = _G[className]

							-- 当前类查找
							local v = myClass[k]
							if v then
								return v
							end

							-- 遍历基类查找
							local baseClsName = myClass._baseClassName
							while baseClsName do
								local base = _G[baseClsName]
								if not base then
									break
								end
								v = base[k]
								if v then
									return v
								end
								baseClsName = base._baseClassName
							end
					end

	cls.create = function(_, ...)
					-- 有哪些基类呢?
					local baseList = List()
					baseList:pushHead(cls)
					local baseClsName = cls._baseClassName
					while baseClsName do
						local base = _G[baseClsName]
						if base then
							baseList:pushHead(base)
						else -- 是个function
							baseList:pushHead(baseClsName)
							break
						end
						baseClsName = base._baseClassName
					end

					-- 逐个构造出来
					local instance = {}
					for _, v in pairs(baseList) do
						if type(v) == 'function' then
							instance = v(...)
						else
							SetClass(instance, v)
							local fnInit = rawget(v, "ctor")
							if fnInit then
								fnInit(instance, ...)
							end
						end
					end
					return instance
				end
end

-----------------------------------------------------------------------
-- 功  能：给toluaObj添加class方法
-- 返回值：toluaObj
-----------------------------------------------------------------------
function SetClass(toluaObj, mt)
    assert(mt.__index, "元表mt必须提供__index方法")
	if type(toluaObj) == 'table' then
		setmetatable(toluaObj, mt)
		return
	end

	local t = tolua.getpeer(toluaObj)
    if not t then
        t = {}
        tolua.setpeer(toluaObj, t)
    end

	setmetatable(t, mt)
end

----------------------------------------------------------------------
-- 功能：UI子类声明, 此函数主要用来减少代码 和 防止UIBase写错
-- 参数className: 类名, 并作为全局变量使用
-- 返回值：nil
----------------------------------------------------------------------
function UIDef(className, uiFile)
	GClass(className, "UIBase")
	local uiClass = _G[className]
 	function uiClass:create(...) -- 创建函数(参数会被传到onCreate中)
		print("★★★ " .. className)
		local self = UIBase:create(uiFile)
        self.__cname = className
		SetClass(self, uiClass)
		UIBase.uiList = UIBase.uiList or {}
		UIBase.uiList[className] = self
		self:onCreate(...) -- 初始化界面

		return self
	end
	return uiClass
end

----------------------------------------------------------------------
-- 功能：节点定义，与UIDef的区别是没有父节点 g_rootNode
function NodeDef(className, uiFile)
	GClass(className, "UIBase")
	local uiClass = _G[className]
    uiClass.__uiFile = uiFile
 	function uiClass:create(...) -- 创建函数(参数会被传到onCreate中)
		print("★★★ " .. className)
		local self = UIBase:create(uiClass.__uiFile)
        self.__cname = className
		SetClass(self, uiClass)
		UIBase.uiList = UIBase.uiList or {}
		UIBase.uiList[className] = self

		self:onCreate(...) -- 初始化界面

		return self
	end
	return uiClass
end

GClass("UIBase")

function cc.Node:changeParentNode(newParent)
	local nd = self
	nd:retain() -- 防止被释放
	nd:removeFromParent()
	newParent:addChild(nd)
	nd:release()
end

function cc.Node:visitAll(fn)
	local function fnVisitAll(nd, fn)
		for k, child in pairs(nd:getChildren()) do
			local bStop = fn(child)
			if bStop then
				return bStop
			end

			bStop = fnVisitAll(child, fn)
			if bStop then
				return bStop
			end
		end
	end

	return fnVisitAll(self, fn)
end

function ccui.Widget:onClicked(callback)
	assert(type(callback) == 'function')
    local function touchEvent(_sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			callback(self)
		end
	end
    -- 设置回调引用,新手引导用
    self._onClickedHandler = callback
	self:addTouchEventListener(touchEvent)
    return self
end

-- 功能：创建UIBase
-- 参数uiName: CocosStudio制作的界面名称
-- 说明：默认父节点g_rootNode
--       改变父节点请用self:changeParentNode
function UIBase:create(uiName)
	local tm = os.clock()
	local self	 = ccui.Widget:create() -- 界面统一ccui
	self:setAnchorPoint(0, 0)
	local ccNode = cc.CSLoader:createNode(uiName)		-- 解析出Node资源

	self._uiFileName = uiName
 	self:setContentSize(ccNode:getContentSize())
 	self:setTouchEnabled(true) -- 防止穿透

	-- 改变父节点为UIWidget
	for k, v in pairs(ccNode:getChildren()) do
		v:changeParentNode(self)
	end
	print(string.format("★★★ 加载界面%s, 耗时: %.2f秒", uiName, os.clock() - tm))

	-- 穿上UIBase的方法
	SetClass(self, UIBase)

	-- 自动注册按钮点击事件和控件名称
	self:_autoRegisterButtonsAndVars()

	return self
end

function UIBase:onCreate()
end

-- 自动注册按钮点击事件和控件名称
function UIBase:_autoRegisterButtonsAndVars()
	self:visitAll(function(child)
					local objName = child:getName()
					if (not objName) or objName == '' then
						return
					end
					self[objName] = child -- 保存直接引用关系

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
					 						local fn = self[eventName]
					 						if fn then
					 							print('点击按钮'.. objName)
					 							fn(self, child)
					 						else
					 							print('缺少按钮事件代码 ' .. eventName)
					 						end
					 					end)
					 end
				end)
end

-- 根据tag查找子节点(不推荐使用这个函数)
function UIBase:getWidgetByTag( nTag )
	local retChild = nil
	self:visitAll(function(child)
		if child and nTag == child:getTag() then
			retChild = child
		end
	end)
	return retChild
end


-- 换掉某个节点
function UIBase:replaceWidget(obj, widget)
	local wid = nil
	if type(obj) == "string" then
		wid = self[obj]
	elseif type(obj) == "userdata" then
		wid = obj
	else
		return
	end
	widget:setPosition(wid:getPosition())
	wid:getParent():addChild(widget)
	wid:removeFromParent()
end



