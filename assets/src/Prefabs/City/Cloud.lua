----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：云层
----------------------------------------------------------------------

local Cloud = class("Cloud", GameObject)

function Cloud:init(args)
    local root = args.root
    self.size = args.root:getInnerContainer():getContentSize()
    self.args = args

    local sprite = cc.Sprite:create(args.name)
    root:addChild(sprite, 100)
    self.sprite = sprite

    local shadow = cc.Sprite:create(args.name)
    root:addChild(shadow)
    shadow:setScale(0.6)
    shadow:setColor(cc.c3b(0, 0, 0))
    shadow:setOpacity(192)
    self.shadow = shadow

    local pos = cc.p(math.random(0, self.size.width), math.random(100, self.size.height - 100))
    self.sprite:setPosition(pos)
    self.shadow:setPosition(cc.pAdd(pos, cc.p(60, -120)))

    self:play(false)
end

function Cloud:play(bInit)
    local pos
    if bInit then
        pos = cc.p(-200, math.random(100, self.size.height - 100))
        self.sprite:setPosition(pos)
        self.shadow:setPosition(cc.pAdd(pos, cc.p(60, -120)))
    else
        pos = cc.p(self.sprite:getPosition())
    end

    local duration = math.random(20.0, 30.0) * (self.size.width - pos.x) / self.size.width
    local tb = 
    {
        cc.MoveBy:create(duration, cc.p(self.size.width + 200, 0)),
        cc.DelayTime:create(math.random(0, 3)),
        cc.CallFunc:create(function() self:play(true) end)
    }
    self.sprite:runAction(cc.Sequence:create(tb))
    self.shadow:runAction(cc.MoveBy:create(duration, cc.p(self.size.width + 200, 0)))
end

return Cloud
