require("DiceSelect")
require("Dice")

display.setStatusBar(display.HiddenStatusBar)

local bg = display.newImage("background.png", true)
bg.x = display.contentWidth / 2
bg.y = display.contentHeight / 2

local ds1 = DiceSelect:new(display.contentCenterX, 100)
--local ds2 = DiceSelect:new(display.contentCenterX, 600)

local d1 = Dice:new("4d6")
d1:out()
d1:test()