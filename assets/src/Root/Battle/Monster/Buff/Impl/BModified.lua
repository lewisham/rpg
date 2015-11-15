----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：修改基本属性
----------------------------------------------------------------------

local BModified = class("BModified", BuffBase)

local mModifyAttribute = {}		--修改的属性信息

mModifyAttribute["attack_up"]				= {"Atk", 1}
mModifyAttribute["attack_down"]				= {"Atk", -1}
mModifyAttribute["critical_up"]				= {"CriRate", 1}
mModifyAttribute["critical_down"]			= {"CriRate", -1}
mModifyAttribute["defence_up"]				= {"Defence", 1}
mModifyAttribute["defence_down"]			= {"Defence", -1}
mModifyAttribute["attack_speed_up"]			= {"AttackSpeed", 1}
mModifyAttribute["attack_speed_down"]		= {"AttackSpeed", -1}
mModifyAttribute["hit_rate_up"]				= {"HitRate", 1}
mModifyAttribute["hit_rate_down"]			= {"HitRate", -1}
mModifyAttribute["glancing_hit_up"]			= {"HitRate", -1}
mModifyAttribute["tenacity_up"]				= {"Tenacity", 1}

-- 构造
function BModified:ctor()
	BModified.super.ctor(self)
	self.mModifiedList = {}
end

-- 初始化
function BModified:init(helper, config)
	BModified.super.init(self, helper, config)
	--lewisPrint(self:getName())
	local attrInfo = mModifyAttribute[self:getName()]
	local monster = helper.mMonster
	
	--修改百分比
	local modifyPer = config.param
	if attrInfo[2] == -1 then
		modifyPer = -modifyPer
	end
	
	local name = attrInfo[1]	--修改属性名
	local unit = {}
	local attribute = monster:getComponent(name)
	local modifyValue = attribute:realityModify(modifyPer)
	unit.name = name
	unit.attribute = attribute
	unit.modifyValue = modifyValue
	table.insert(self.mModifiedList, unit)
	
	self:onEffect(true)
end

--开启或关闭buff影响
function BModified:onEffect(bEffect)
	for key, unit in pairs(self.mModifiedList) do
		local modifyValue = unit.modifyValue
		if bEffect == false then
			modifyValue = -modifyValue
		end
		unit.attribute:modifyCurrent(modifyValue)
		--lewisPrint("modify value", bEffect, unit.name, modifyValue)
	end
end


--清除buff
function BModified:onCleanup()
	self:onEffect(false)
	BModified.super.onCleanup(self)
end

return BModified