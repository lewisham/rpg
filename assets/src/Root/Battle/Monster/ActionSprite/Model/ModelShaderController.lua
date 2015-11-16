----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2015-4-28
-- 描述：shader controller
----------------------------------------------------------------------

local ModelShaderController = class("ModelShaderController", function() return cc.Node:create() end)

local mShaderFiles = {}
local mRootPath = "MonsterShader/"
mShaderFiles["frozen"]      = "frozen.fsh"
mShaderFiles["fire"]        = "fire.fsh"
mShaderFiles["dot"]         = "dot.fsh"


function ModelShaderController:ctor()
    self.mStateList = {}
    self.mStateIdx = 0
    self.mShaderCache = {}
    self.mArmature = nil
end

function ModelShaderController:init(armature)
    self.mArmature = armature
    self:initCachce()

    local function update(dt)
		self:update(dt)
	end
	self.mTimer = 10
	self:scheduleUpdateWithPriorityLua(update, 0)

    self.mStateList = {"fire", "dot", "frozen"}
end

local maxTimer = 2.0
function ModelShaderController:update(dt)
    self.mTimer = self.mTimer + dt
    if self.mTimer < maxTimer then
        return
    end
    self.mTimer = 0
    self:changeState()
end

function ModelShaderController:changeState()
    local idx = self.mStateIdx
    self:nextState(self.mStateList[idx])
    idx = idx + 1
    if idx > #self.mStateList then
        idx = 1
    end
    self.mStateIdx = idx
end

function ModelShaderController:initCachce()
    for key, val in pairs(mShaderFiles) do
        local vsh = mRootPath.."common.vsh"
        local fsh = mRootPath..val
        print(vsh, fsh)
        local glprogram = cc.GLProgram:createWithFilenames(vsh, fsh)
        local state = cc.GLProgramState:getOrCreateWithGLProgram(glprogram)
        state:retain()
        self.mShaderCache[key] = state
    end
end

function ModelShaderController:nextState(name)
    local state = self.mShaderCache[name]
	if state == nil then
		return
	end
    local list = self.mArmature:getBoneDic()
    for _, bone in pairs(list) do
        bone:setGLProgramState(state)
	end
end


return ModelShaderController
