require("DiceSelect")
require("Dice")

display.setStatusBar(display.HiddenStatusBar)

local bg = display.newImage("background.png", true)
bg.x = display.contentWidth / 2
bg.y = display.contentHeight / 2

local ds1 = DiceSelect:new(display.contentCenterX, 100)
--local ds2 = DiceSelect:new(display.contentCenterX, 600)

local d1 = Dice:new("4d6")
local d2 = Dice:new("2d4")
local d3 = Dice:parse("4d6 2d4")

d1.out()
d2.out()
d3.out()
