Common = {}

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
	-- 加载图片资源
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

-- 创建怪物骨骼动画
function Common.createMonsterArmature(tb)
	Common.loadMonsterArmature(tb.fileName, tb.armatureStyle)
	if tb.armatureStyle then
		return ccs.Armature:create(tb.armatureName, tb.armatureStyle)
	else
		return ccs.Armature:create(tb.armatureName) 
	end
end