------------------------------------------------------------------------------
-- Dragon Dice
-- Copyright (c) 2012 by Phil Callister. All Rights Reserved.
--
-- Dice.lua => A single die. Will need to support polyhedral
--
local easingx  = require("scripts.corona.easingx")
local physics = require("physics")

Dice = {}

function Dice:new(x, y, diceType)
    local dice = display.newSprite(diceType.sheet, diceType.sequence)
    dice.selected = false  -- Initial create sends an extra "tap" event
                           -- to the dice.  Soooooo, a bit of a bug here,
                           -- in that the dice is set initially to NOT being
                           -- selected, however, the extra "tap" WILL select it.

    dice.recycle = false -- recycle dice status flag
    dice.sides = diceType.sides
    dice:setSequence("diceFinal")
    dice:setFrame(math.random (diceType.sides))
    dice.rotation = math.random(1, 360)
    dice:translate(x, y)
    dice.xScale = 0.5; dice.yScale = 0.5
    transition.to(dice, { time=500, xScale=1.0, yScale=1.0, transition=easingx.easeOutElastic })        
    physics.addBody(dice, { density=0.2, friction=0.3, bounce=0.1, shape=diceType.shape })
    dice.linearDamping = 3
    dice.angularDamping = 5

    --------------------------------------------------------------------------
    -- Sprite sequence to rolling dice
    function dice:rollSequence()
        dice:setSequence("diceRoll")
    end

    --------------------------------------------------------------------------
    -- Sprite sequence to final dice
    function dice:finalSequence()
        dice:setSequence("diceFinal")
    end

    --------------------------------------------------------------------------
    -- Select / Deselect dice
    function dice:toggleSelect()
        dice.xScale = 0.5; dice.yScale = 0.5
        transition.to(dice, { time=500, xScale=1.0, yScale=1.0, transition=easingx.easeOutElastic })        
        dice.selected = not dice.selected
        if (dice.selected) then
            dice:setFillColor(255, 59, 20, 255)
        else
            dice:setFillColor(255, 255, 255)
        end
    end

    --------------------------------------------------------------------------
    -- recycle flag
    function dice:setRecycle(r)
        dice.recycle = r
    end
    function dice:isRecycle()
        return dice.recycle
    end

    --------------------------------------------------------------------------
    -- Dice selected? true/false
    function dice:isSelected()
        return dice.selected
    end

    return dice
end

return Dice
