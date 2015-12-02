----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：全屏剧情
----------------------------------------------------------------------

local UICity = class("UICity", GameObject)

function UICity:init(args)
    local root = self:getScene():getRoot()
    local sky = cc.LayerGradient:create(cc.c4b(0,55,120,255), cc.c4b(40,150,200,255), cc.p(0.9, 0.9))
    root:addChild(sky)
    self:loadCsb(args.filename)
    self:createBuildings()
end

function UICity:createBuildings()
    local children = self.building_node:getChildren()
    for _, child in pairs(children) do
        local node = UIBase:create()
        node:onCreate(string.format("City/Buildings/%s.csb", child:getName()))
        --node:setScale(0.8)
        node.btn:onClicked(function() self:clickBuild(child) end)
        child:addChild(node)
    end
end

function UICity:clickBuild(build)
    print(build:getName())
end


return UICity
