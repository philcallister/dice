require("scripts.DiceSelect")
require("scripts.DiceParser")
require("scripts.RollStandard")

display.setStatusBar(display.HiddenStatusBar)

local ds1 = DiceSelect:new(display.contentCenterX, 100)

-- @@@@@ Just for testing right now...
local d1 = DiceParser:new("4d6")
d1:test()