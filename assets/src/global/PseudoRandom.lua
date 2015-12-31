----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：伪随机数序列
----------------------------------------------------------------------

PseudoRandom = {}

local a = 997
local b = 3697
local c = 9923

local a = 1847 
local b = 5437
local c = 41513

local n = 1
local first = 1

function PseudoRandom.init(fa, fb, fc, fn)
	a = fa
	b = fb
	c = fc
	n = fn
end

function PseudoRandom.setRand(fn)
	n = fn
	first = n
end

-- 获得首个随机数
function PseudoRandom.getFirst()
	return first
end

function PseudoRandom.seed()
	local n1 = a * n + b
	n1 = math.fmod(n1, c)
	--lewisPrint(n1, n)
	n = n1
	return n1
end

--local bTest = false

function PseudoRandom.random(m, n)
	local seed = PseudoRandom.seed()
	if m > n then
		local tmp = m
		m = n
		n = tmp
	end
	local l = n - m + 1
	if l <= 0 then
		return m
	end
	local ret = math.fmod(seed, l) + m
	return ret
end


local function test1()
	local tb = {}
	for i = 1, c do
		local s = PseudoRandom.seed()
		if tb[s] == nil then
			tb[s] = i
		else
			print("repeat count", tb[s], i)
			break
		end
	end
end

local function test2()
	local tb = {}
	for i = 1, c do
		local ret = PseudoRandom.random(0,100)
		lewisPrint(ret)
	end
end

test1()
--test2()