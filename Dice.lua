local lpeg = require"lpeg"

Dice = {}
function Dice:new(notation)
	local dice = {}
	dice.notation = notation

	function dice:out()
		print(">>>>> ", dice.notation)
	end

	function dice:parse()

		-- Lexical Elements
		local Space = lpeg.S(" \n\t")^0
		local Number = lpeg.C(lpeg.P"-"^-1 * lpeg.R("09")^1) * Space
		local FactorOp = lpeg.C(lpeg.S("+-")) * Space
		local TermOp = lpeg.C(lpeg.S("*/")) * Space
		local DiceOp = lpeg.C(lpeg.S("d")) * Space
		local Open = "(" * Space
		local Close = ")" * Space

		-- Auxiliary function
		function eval (v1, op, v2)
		  if (op == "+") then return v1 + v2
		  elseif (op == "-") then return v1 - v2
		  elseif (op == "*") then return v1 * v2
		  elseif (op == "/") then return v1 / v2
		  elseif (op == "d") then return rolls(v1, v2)
		  end
		end

		function rolls(v1, v2)
			return v1 * v2
		end

		-- Grammar
		local V = lpeg.V
		G = lpeg.P { "Exp",
		  Exp = lpeg.Cf(V"Factor" * lpeg.Cg(FactorOp * V"Factor")^0, eval);
		  Factor = lpeg.Cf(V"Term" * lpeg.Cg(TermOp * V"Term")^0, eval);
		  Term = lpeg.Cf(V"Dice" * lpeg.Cg(DiceOp * V"Dice")^0, eval);
		  Dice = Number / tonumber + Open * V"Exp" * Close;
		}

		return lpeg.match( G, dice.notation )
	end

	function dice:test()
		dice.notation = "3+5*9/(1+1) - 12"; assert(dice:parse() == 13.5, "error...test1") -- test1
		dice.notation = "10+10-10-10"; assert(dice:parse() == 0, "error...test2") -- test2
		dice.notation = "4d6"; assert(dice:parse() == 24, "error...test3") -- test3
	end

	return dice
end
return Dice