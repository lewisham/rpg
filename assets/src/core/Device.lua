device = {}

local target = cc.Application:getInstance():getTargetPlatform()

function device.isWindows()
	return target == cc.PLATFORM_OS_WINDOWS
end

function device.isMac()
	return target == cc.PLATFORM_OS_MAC
end

function device.isAndroid()
	return target == cc.PLATFORM_OS_ANDROID
end

function device.isIOS()
	return target == cc.PLATFORM_OS_IPHONE or target == cc.PLATFORM_OS_IPAD
end
