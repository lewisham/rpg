--	让lua文件重复加载
local function HookRequire()
	local oldRequire = require;
	local fileUtil = cc.FileUtils:getInstance();
	local modules = {};
	local lastModule;
	local lastModuleNew;
	local requireTimer = 0;
	
	--	获得模块的最后更新时间
	local function GetModuleLastWriteTime(moduleName)
		local fileName = string.gsub(moduleName, '%.','%/');
		fileName = fileName..".lua";
		local t = fileUtil:getFileModifyTime(fileName);
		if t > 0 then 
			return t;
		end
	end
	
	--	根据需要清除模块的加载标志
	local function ClearLoadFlag(moduleInfo)
		--	限制在同一次大的require中重复进入
		if moduleInfo.requireTimer == requireTimer then
			return moduleInfo.clearLoadFlag;
		end
		
		moduleInfo.requireTimer = requireTimer;
		moduleInfo.clearLoadFlag = nil;
		
		--	子模块
		local bChanged;
		if moduleInfo.childs then
			for i,v in ipairs(moduleInfo.childs) do
				if ClearLoadFlag(v) then
					bChanged = true;
				end
			end
		end
		
		--	文件修改时间
		local t = GetModuleLastWriteTime(moduleInfo.name);
		if t and t ~= moduleInfo.lastWriteTime then
			bChanged = true;
			moduleInfo.lastWriteTime = t;
			print(moduleInfo.name.." changed outside");
		end
	
		if bChanged then
			--	清除标志 
			moduleInfo.clearLoadFlag = true;
			package.loaded[moduleInfo.name] = nil;
		end
		
		return moduleInfo.clearLoadFlag;
	end
	
	require = function (moduleName)
		--print("require "..moduleName);
		if not lastModule then
			--	根文件的require, require数递增
			requireTimer = requireTimer + 1;
		end
		
		local moduleInfo = modules[moduleName];
		local moduleNew;
		if moduleInfo then
			--	模块已经存在，清除加载标志
			ClearLoadFlag(moduleInfo);
		else
			--	模块不存在，创建
			moduleInfo = {};
			modules[moduleName] = moduleInfo;
			moduleInfo.name = moduleName;
			moduleInfo.lastWriteTime = GetModuleLastWriteTime(moduleName);
			moduleInfo.requireTimer = requireTimer;
			moduleInfo.clearLoadFlag = true;
			moduleNew = true;
		end
		
		if lastModule and lastModuleNew then
			if not lastModule.childs then
				lastModule.childs = {};
			end
			table.insert(lastModule.childs, moduleInfo);
		end
		
		--	加载模块
		local oldLastModule = lastModule;
		local oldLastModuleNew = lastModuleNew;
		lastModule = moduleInfo;
		lastModuleNew = moduleNew;
			
		local success,ret = pcall(oldRequire,moduleName);
		
		lastModule = oldLastModule;
		lastModuleNew = oldLastModuleNew;
		
		if not success then
			--print("require error:"..ret);
			--	没加载成功，去掉新创建的模块信息，这样下次才会加载
			if moduleNew then
				modules[moduleName] = nil;
			end
			
			--	向上传递错误，如果没传递，应该清除childs中的引用
			error(ret,0);
		end
		return ret;
	end
end

print("hook require to auto reload file");
HookRequire();