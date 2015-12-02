----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：攻击力
----------------------------------------------------------------------

local Atk = class("Atk", AttributeBase)

-- 构造
function Atk:ctor()
	Atk.super.ctor(self)
end

-- 初始化
function Atk:init(args)
    self:initConfig(args.atk, args.atk)
end

return Atk
