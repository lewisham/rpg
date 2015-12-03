Common = {}

-- ��obj��Ӷ�Ӧ��ķ���
function setClass(obj, cls)
    for name, val in pairs(cls) do
        if obj[name] == nil then
            obj[name] = val
        end
    end
end

function Common.loadSpriteFrames(name)
	local df = cc.Texture2D:getDefaultAlphaPixelFormat()
	--local cf = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444
	local cf = df
	cc.Texture2D:setDefaultAlphaPixelFormat(cf)
	cc.SpriteFrameCache:getInstance():addSpriteFrames(name)
	cc.Texture2D:setDefaultAlphaPixelFormat(df)
end

-- tag = DONOT_LOAD_TEXTURE
function Common.loadMonsterArmature(name, style)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("DONOT_LOAD_TEXTURE", "DONOT_LOAD_TEXTURE", name)
	local plists = lus_get_armature_need_plist_file(name)
	--Log(plists)
	-- ����ͼƬ��Դ
	if plists then
		for _, plistName in pairs(plists) do
			if style == nil then
				Common.loadSpriteFrames(plistName)
			else
				local styleName = mStyleNameList[style]
				local newPlistName= string.gsub(plistName, "fire", styleName)
				Common.loadSpriteFrames(newPlistName)
			end
		end
	end
end

-- ���������������
function Common.createMonsterArmature(tb)
	Common.loadMonsterArmature(tb.fileName, tb.armatureStyle)
	if tb.armatureStyle then
		return ccs.Armature:create(tb.armatureName, tb.armatureStyle)
	else
		return ccs.Armature:create(tb.armatureName) 
	end
end

----------------------------------------------------------------------
-- ���ߣ�lewis
-- ���ڣ�2013-3-31
-- ������ս��ȫ�ֺ���
----------------------------------------------------------------------
g_MonsterRoot = nil
g_BattleRoot = nil
g_UIScene = nil

-- ������Ϸ��
function createGameScene(path, name)
    local ret = require(path).new()
    ret:createRoot()
    ret:init()
    return ret
end

function safeRemoveNode(node)
    if not node then return end
    node:removeFromParent(true)
end

-- ��������
function createMonster(id, pos, group, fidx)
    local config = monster_config[id]
    local tb = clone(config)
    tb.model = clone(monster_model[tb.model_id])
    local ret = require("Prefabs.Monster.Monster").new()
    ret:init({config = tb, position = pos, group = group, fidx = fidx})
    findObject("Camp"):addActor(ret)
    return ret
end

-- ��������
function createPhantasm(monster)
    local group = monster:getComponent("GroupID")
    local places = findObject("ActionList"):getEmptyPlace(group)
    local list = {}
    for _, idx in pairs(places) do
        local pos = calcFormantionPos(idx, group)
        local monster_id = monster._args.config.id
        --monster_id = 10003
        local ret = createMonster(monster_id, pos, group, idx)
        ret:addChild("Phantasm", true)
        findObject("ActionList"):addActor(ret)
        --ret:getComponent("MStatusBar"):setVisible(true)
        ret:getComponent("ActionSprite"):changeState("idle")
        table.insert(list, ret)
    end
    return list
end

-- Ԥ���ع�����Դ
function preloadMonsterRes(id)
    local config = monster_model[monster_config[id].model_id]
    local name = config.model
	local path = "monster/"..name.."/"..name..".ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
end

-- ����λ��
SCENE_MAP_WIDTH = 1024
function calcFormantionPos(id, group)
    local offset = 120
    local list2 = {cc.p(0, 0), cc.p(offset, 0), cc.p(-offset, 0), cc.p(0, -offset), cc.p(0, offset)}
    local x = (SCENE_MAP_WIDTH - 1024) / 2 + 200
    local list1 = {cc.p(x, 256), cc.p(SCENE_MAP_WIDTH - x, 256)}
    local pos = cc.pAdd(list1[group], list2[id])
    return pos
end

-- �����ƶ���
function cameraMoveTo(pos, duration)
    if g_UIScene == nil then return end
    g_UIScene:cameraMoveTo(pos, duration)
end