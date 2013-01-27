------------------------------------------------------------------------------
-- Dragon Dice
-- Copyright (c) 2012 by Phil Callister. All Rights Reserved.
--
-- DiceDropper.lua => Drop yer dice
--
local physics = require("physics")

DiceDropper = {}


--------------------------------------------------------------------------
-- Private Methods
--------------------------------------------------------------------------


--------------------------------------------------------------------------
-- Public Class Interface
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- New dropper
function DiceDropper:new(x, y, dropDice)
    local dropper = display.newRoundedRect(x, y, 125, 650, 20)
    physics.addBody(dropper, "static", { friction=0.3, bounce=0.5 })
    dropper.strokeWidth = 10
    dropper:setFillColor(56, 127, 90)
    dropper:setStrokeColor(40, 90, 64)
    dropper.dice = {}


    --------------------------------------------------------------------------
    -- Public Interface
    --------------------------------------------------------------------------

    --------------------------------------------------------------------------
    -- Enable for dropping
    function dropper:enableDrop()
        self.isSensor = true
    end

    --------------------------------------------------------------------------
    -- Disable for dropping
    function dropper:disableDrop()
        self.isSensor = false
    end

    --------------------------------------------------------------------------
    -- Add dice to dropper
    function dropper:addDice(dice)
        dice.isSensor = true
        dice.x = 10
        dice.y = 200
    end

    return dropper
end

return DiceDropper