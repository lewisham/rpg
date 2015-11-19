----------------------------------------------------------------------
-- 作者：lewis
-- 日期：2013-3-31
-- 描述：全屏剧情
----------------------------------------------------------------------

local UIFStory = NodeDef("UIFStory", "Layout/CG/FStory.csb")

function UIFStory:init()
    self:onCreate()
    g_BattleRoot:addChild(self)
end

function UIFStory:play(co)
    self.bg:setOpacity(0)
    self.bg:runAction(cc.FadeIn:create(0.3))
    co:waitForSeconds(0.3)
    co:waitForSeconds(1.0)
end

-- 字符百分比切分
function stringSplitByPercent(input, percent)
    local total = math.floor(string.utf8len(input) * percent / 100)
    local len  = string.len(input)
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1

        if cnt >= total then
            break
        end
    end
    left = len - left
    local str1 = string.sub(input, 1, left)
    local str2 = string.sub(input, left + 1, len)
    --print("left", left, str1, str2, input)
    return str1, str2
end

function UIFStory:drawString(str)
    local maxWidth = self.word_node:getContentSize().width
    local leftWidth = maxWidth
    local y = 0
    while true do
        local bBreak = true
        local label = ccui.Text:create()
        label:setFontName("")
        label:setFontSize(18)
        label:setString(str)

        local x = maxWidth - leftWidth
        local width = label:getContentSize().width

        if width > leftWidth then
            local str1, str2 = stringSplitByPercent(str, leftWidth / width * 100)
            label:setString(str1)
            str = str2
            label:setPositionX(x, y)
            self.word_node:addChild(label)
            x = 0
            y = y + 40
            bBreak = false
        else
            leftWidth = leftWidth - width
            label:setPositionX(x, y)
            self.word_node:addChild(label)
            bBreak = true
        end
        if bBreak then break end
    end
end

return UIFStory
