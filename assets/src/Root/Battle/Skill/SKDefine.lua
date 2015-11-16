require "Root.Battle.Skill.Base.SKBase"
require "Root.Battle.Skill.Base.SKLogic"
require "Root.Battle.Skill.Base.SKDisplay"

require "Root.Battle.Skill.SKEvent"

-- 技能位置定义
PositionType = 
{
    PT1 = 1,        -- 目标正前方
    PT2 = 2,        -- 已方原始位置
    PT3 = 3,        -- 已方当前位置
    PT4 = 4,        -- 目标当前位置
    PT5 = 5,        -- 已方阵型中心
    PT6 = 6,        -- 敌方阵型中心
    PT7 = 7,        -- 战场正中心
}

Monster_State =
{
    JiTui = "JiTui",
}
