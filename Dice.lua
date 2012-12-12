local lpeg = require"lpeg"

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

        ----------------------------------------------------------------------
        -- Lexical Elements
        local Space = lpeg.S(" \n\t")^0
        local Number = lpeg.C(lpeg.P"-"^-1 * lpeg.R("09")^1) * Space
        local Low = lpeg.C(lpeg.P("L")) * Space
        local High = lpeg.C(lpeg.P("H")) * Space
        local FactorOp = lpeg.C(lpeg.S("+-")) * Space
        local TermOp = lpeg.C(lpeg.S("*/")) * Space
        local DiceOp = lpeg.C(lpeg.P("d")) * Space
        local Open = "(" * Space
        local Close = ")" * Space

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

        ----------------------------------------------------------------------
        -- Add
        function add(v1, v2)
            print("+++++add", v1, v2)

            -- Keep Low or High
            if (v2 == "L") then
                return keepLow()
            elseif (v2 == "H") then
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

            -- Keep Low or High
            if (v2 == "L") then
                return throwLow()
            elseif (v2 == "H") then
                return throwHigh()
                
            -- Subtract
            else
                return v1 - v2
            end
        end

        ----------------------------------------------------------------------
        -- Keep
        function keepLow()
            local m, i = min(dice.pairs[#dice.pairs].r)
            dice.pairs[#dice.pairs].r = {i}
            print("<<<<<keepLow", m, i)
            return m
        end

        function keepHigh()
            local m, i = max(dice.pairs[#dice.pairs].r)
            dice.pairs[#dice.pairs].r = {i}
            print(">>>>>keepHigh", m, i)
            return m
        end

        ----------------------------------------------------------------------
        -- Throw
        function throwLow()
        end

        function throwHigh()
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

        ----------------------------------------------------------------------
        -- Roll the dice
        function roll(multiplier, sides)
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
        v = 20; dice.notation = "1d20"; assert(dice:parse() == v, "{test #1} error: " .. v)
        v = 9; dice.notation = "(3d6+H)+(4d6+L)"; assert(dice:parse() == v, "{test #2) error: " .. v)
    end

    return dice
end
return Dice