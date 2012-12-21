------------------------------------------------------------------------------
-- Dragon Dice
-- Copyright (c) 2012 by Phil Callister. All Rights Reserved.
--
-- Dice.lua => A single 6-sided die. Will need to support polyhedral
--             in the future.
--
local easingx  = require("scripts.corona.easingx")
local physics = require("physics")

Dice = {}

Dice.sequence = { {name="diceRoll", start=1, count=24, time=500},
                  {name="diceFinal", start=25, count=6, time=0} }
Dice.options = {
    -- Required params
    width = 130, --130 (65)
    height = 130, -- 130 (65)
    numFrames = 30,
    -- content scaling
    sheetContentWidth = 3900, -- 3900 (1950)
    sheetContentHeight = 130 -- 130 (65)
}
Dice.sheet = graphics.newImageSheet( "sprites/d6/sprite.png", Dice.options )
Dice.shape = { -36,-36, 36,-36, 36,36, -36,36 }

function Dice:new(x, y, side)
    local dice = display.newSprite(Dice.sheet, Dice.sequence)
    dice.selected = false -- Initial create sends an extra "tap" event
                          -- to the dice.  Soooooo, a bit of a bug here,
                          -- in that the dice is set initially to NOT being
                          -- selected, however, the extra "tap" WILL select it.
    dice:setSequence("diceFinal")
    if (side) then
        dice:setFrame(side)
    else
        dice:setFrame(math.random (6))
    end
    dice.rotation = math.random( 1, 360 )
    dice:translate(x, y)
    dice.xScale = 0.5; dice.yScale = 0.5
    transition.to(dice, { time=500, xScale=1.0, yScale=1.0, transition=easingx.easeOutElastic })        
    physics.addBody(dice, { density=0.2, friction=0.3, bounce=0.1, shape=Dice.shape })
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
    -- Dice selected? true/false
    function dice:isSelected()
        return dice.selected
    end

    return dice
end

return Dice
