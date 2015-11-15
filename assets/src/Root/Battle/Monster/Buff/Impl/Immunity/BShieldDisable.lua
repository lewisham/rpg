----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：免役护盾buff
----------------------------------------------------------------------

local BShieldDisable = class("BShieldDisable", require("Root.Battle.Monster.Buff.Impl.Immunity.BImmunity"))

--初始化
function BShieldDisable:init(helper, config)
	config.param = "203"
	BShieldDisable.super.init(self, helper, config)
end

return BShieldDisable