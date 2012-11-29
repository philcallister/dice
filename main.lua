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



-- @@@@@ Quick LPEG Test: v2012.971 @@@@

local lpeg = require"lpeg"

-- Lexical Elements
local Space = lpeg.S(" \n\t")^0
local Number = lpeg.C(lpeg.P"-"^-1 * lpeg.R("09")^1) * Space
local FactorOp = lpeg.C(lpeg.S("+-")) * Space
local TermOp = lpeg.C(lpeg.S("*/")) * Space
local Open = "(" * Space
local Close = ")" * Space

-- Auxiliary function
function eval (v1, op, v2)
  if (op == "+") then return v1 + v2
  elseif (op == "-") then return v1 - v2
  elseif (op == "*") then return v1 * v2
  elseif (op == "/") then return v1 / v2
  end
end

-- Grammar
local V = lpeg.V
G = lpeg.P{ "Exp",
  Exp = lpeg.Cf(V"Factor" * lpeg.Cg(FactorOp * V"Factor")^0, eval);
  Factor = lpeg.Cf(V"Term" * lpeg.Cg(TermOp * V"Term")^0, eval);
  Term = Number / tonumber + Open * V"Exp" * Close;
}

-- small example
print(">>>>> LPeg Test: ", lpeg.match( G, "3 + 5*9 / (1+1) - 12") )
