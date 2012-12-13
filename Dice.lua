local lpeg = require"lpeg"

local LOW = "L"
local HIGH = "H"

----------------------------------------------------------------------
-- Lexical Elements
local Space = lpeg.S(" \n\t")^0
local Number = lpeg.C(lpeg.P"-"^-1 * lpeg.R("09")^1) * Space
local Low = lpeg.C(lpeg.P(LOW)) * Space
local High = lpeg.C(lpeg.P(HIGH)) * Space
local FactorOp = lpeg.C(lpeg.S("+-")) * Space
local TermOp = lpeg.C(lpeg.S("*/")) * Space
local DiceOp = lpeg.C(lpeg.P("d")) * Space
local Open = "(" * Space
local Close = ")" * Space

Dice = {}
function Dice:new(notation)

    local dice = {}
    dice.notation = notation
    dice.pairs = {}

    ----------------------------------------------------------------------
    -- Random roll: bit of a kludge here as we accept the current roll
    -- "num".  This is only used for testing.  For actual rolls, we only
    -- create a random number from the given "sides" 
    dice.random = function(num, sides)
        return math.random (sides)
    end

    --------------------------------------------------------------------------
    -- Parse the dice
    --------------------------------------------------------------------------
    function dice:parse()
        print("dice:parse -------------------------")

        dice.pairs = {} -- dice reset

        ----------------------------------------------------------------------
        -- Add
        function add(v1, v2)
            print("+++++add", v1, v2)

            -- Keep Low or High
            if (v2 == LOW) then
                return keepLow()
            elseif (v2 == HIGH) then
                return keepHigh()

            -- Add
            else
                return v1 + v2
            end
        end

        ----------------------------------------------------------------------
        -- Subtract
        function subtract(v1, v2)
            print("-----subtract", v1, v2)

            -- Throw Low or High
            if (v2 == LOW) then
                return throwLow()
            elseif (v2 == HIGH) then
                return throwHigh()
                
            -- Subtract
            else
                return v1 - v2
            end
        end

        ----------------------------------------------------------------------
        -- Keep
        function keepLow()
            local a = dice.pairs[#dice.pairs].r
            local m, i = min(a)
            a = {i}
            print("<<<<<keepLow", m, i)
            return m
        end

        function keepHigh()
            local a = dice.pairs[#dice.pairs].r
            local m, i = max(a)
            a = {i}
            print(">>>>>keepHigh", m, i)
            return m
        end

        ----------------------------------------------------------------------
        -- Throw
        function throwLow()
            local a = dice.pairs[#dice.pairs].r
            local m, i = min(a)
            print("<<<<<throwLow", m, i)
            table.remove(a, i)
            return total(a)
        end

        function throwHigh()
            local a = dice.pairs[#dice.pairs].r
            local m, i = max(a)
            print(">>>>>throwHigh", m, i)
            table.remove(a, i)
            return total(a)
        end

        ----------------------------------------------------------------------
        -- Min / Max + index
        function min(a)
            local mi = 1    -- minimum index
            local m = a[mi] -- minimum value
            for i,val in ipairs(a) do
                if (val < m) then
                    mi = i
                    m = val
                end
            end
            return m, mi
        end

        function max(a)
            local mi = 1    -- maximum index
            local m = a[mi] -- maximum value
            for i,val in ipairs(a) do
                if (val > m) then
                    mi = i
                    m = val
                end
            end
            return m, mi
        end

        function total(a)
            local total = 0
            for i = 1, #a do
                total = total + a[i]
            end
            return total
        end

        ----------------------------------------------------------------------
        -- Roll the dice
        function roll(multiplier, sides)
            multiplier = multiplier and multiplier or 1
            print("roll:", multiplier, sides)

            local total = 0
            local rolls = {}
            for i = 1, multiplier do
                rolls[i] = dice.random(i, sides)
                print("rrrrr", rolls[i])
                total = total + rolls[i]
            end
            local pair = {
                m = multiplier,
                s = sides,
                r = rolls
            }
            table.insert(dice.pairs, pair)
            return total
        end

        ----------------------------------------------------------------------
        -- Auxiliary evaluation function
        function eval (v1, op, v2)
            print("eval: ", v1, op, v2)
            if (op == "+") then return add(v1, v2)
            elseif (op == "-") then return subtract(v1, v2)
            elseif (op == "*") then return v1 * v2
            elseif (op == "/") then return v1 / v2
            elseif (op == "d") then return roll(v1, v2)
            end
        end

        ----------------------------------------------------------------------
        -- Grammar
        local V = lpeg.V
        G = lpeg.P { "Exp",
            Exp = lpeg.Cf(V"Factor" * lpeg.Cg(FactorOp * V"Factor")^0, eval);
            Factor = lpeg.Cf(V"Term" * lpeg.Cg(TermOp * V"Term")^0, eval);
            Term = lpeg.Cf(V"Dice" * lpeg.Cg(DiceOp * V"Dice")^0, eval);
            Dice = Number / tonumber + Low + High + Open * V"Exp" * Close;
        }

        return lpeg.match( G, dice.notation )

    end

    --------------------------------------------------------------------------
    -- Unit Testing
    --------------------------------------------------------------------------
    function dice:test()

        ----------------------------------------------------------------------
        -- Random roll - nope...deterministic override for testing
        dice.random = function(num, sides)
            local random = 1
            if (sides - num + 1 > 0) then
                random = sides - num + 1
            end
            return random
        end

        ----------------------------------------------------------------------
        -- Tests
        v = 20; dice.notation = "1d20"; assert(dice:parse() == v, "{test #1} error: " .. v); print("{test #1} passed")
        -- @@@@@ TODO: Would like to get this working
        --v = 10; dice.notation = "d10"; assert(dice:parse() == v, "{test #2} error: " .. v); print("{test #2} passed")
        v = 39; dice.notation = "2d20"; assert(dice:parse() == v, "{test #3} error: " .. v); print("{test #3} passed")
        v = 30; dice.notation = "4d8+4"; assert(dice:parse() == v, "{test #4} error: " .. v); print("{test #4} passed")
        v = 27; dice.notation = "3d4+4d6"; assert(dice:parse() == v, "{test #5) error: " .. v); print("{test #5} passed")
        v = 9; dice.notation = "6d12+L+2"; assert(dice:parse() == v, "{test #6) error: " .. v); print("{test #6} passed")
        v = 15; dice.notation = "5d20+H-5"; assert(dice:parse() == v, "{test #7) error: " .. v); print("{test #7} passed")
        v = 13; dice.notation = "(3d10+H)+(4d6+L)"; assert(dice:parse() == v, "{test #8) error: " .. v); print("{test #8} passed")
        v = 26; dice.notation = "5d8-L"; assert(dice:parse() == v, "{test #9) error: " .. v); print("{test #9} passed")
        v = 14; dice.notation = "10d4-H+2"; assert(dice:parse() == v, "{test #10) error: " .. v); print("{test #10} passed")
        v = 37; dice.notation = "(4d20-H)-(4d10-L)+10"; assert(dice:parse() == v, "{test #11) error: " .. v); print("{test #11} passed")
    end

    return dice
end
return Dice