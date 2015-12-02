----------------------------------------------------------------------
-- ���ߣ�lewis
-- ���ڣ�2013-3-31
-- ��������Ϸ����
----------------------------------------------------------------------

GameObject = class("GameObject")


local mInstanceId = 0

-- ���캯��
function GameObject:ctor()
    self.mProperty = {}
    self.mComponents = {}
    self.mGameScene = nil
    self.mRefCnt   = 1
	self.mInstanceId = getInstanceId()
end

function GameObject:init()
end

-- ���ʵ��id
function GameObject:getInstanceId()
	return self.mInstanceId
end

-- ��ȡ��������
function GameObject:get(name)
    local ret = self.mProperty[name]
    return ret
end

-- ���û�������
function GameObject:set(name, value)
    self.mProperty[name] = value
end

function GameObject:release()
    self.mRefCnt = self.mRefCnt - 1
end

-- ������
function GameObject:getSelf()
    if self.mRefCnt == 0 then return nil end
    return self
end

-- ������ӵ��ĳ���
function GameObject:getScene()
    return self.mGameScene
end

-- ����csb
function GameObject:loadCsb(filename)
    local node = UIBase.new()
    node.mDelegate = self
    node:onCreate(filename)
    self:getScene():getRoot():addChild(node)
    self.mRoot = node
end

function GameObject:getRoot()
    return self.mRoot
end

--------------------------------------
-- �������
--------------------------------------

-- �ӳ������Ƴ�
function GameObject:removeFromScene(args)
end

-- �������
function GameObject:createComponent(filename, args, name)
	local path = self.ROOT_PATH.."."..filename
    local cls = require(path)
	local ret = cls.new()
    name = name or ret.__cname
	ret.mGameOject = self
    self.mComponents[name] = ret
    ret.__path = path
	ret:init(args)
    return ret
end

-- �������
function GameObject:addComponent(name, val)
    self.mComponents[name] = val
end

-- �������
function GameObject:findComponent(name)
    return self.mComponents[name]
end

-- �Ƴ����
function GameObject:removeComponent(args)
    local obj = self:findComponent(name)
    if obj == nil then return end
    self.mComponents[name] = nil
    obj:removeFromObject(args)
end

return GameObject