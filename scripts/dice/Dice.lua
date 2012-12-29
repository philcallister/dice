------------------------------------------------------------------------------
-- Dragon Dice
-- Copyright (c) 2012 by Phil Callister. All Rights Reserved.
--
-- Dice.lua => A single die. Will need to support polyhedral
--
local easingx  = require("scripts.corona.easingx")
local physics = require("physics")
local widget = require("widget")

Dice = {}

--------------------------------------------------------------------------
-- Private Methods
--------------------------------------------------------------------------
local function releaseDeleteButton(event)
    print(">>>>> releaseDeleteButton")
end

local function newDeleteButton(x, y)
    local button = widget.newButton
    {
        default = "images/dice-delete.png",
        over = "images/dice-delete-over.png",
        onRelease = releaseDeleteButton
    }
    button.x = x
    button.y = y
    return button
end

--------------------------------------------------------------------------
-- Public Class Interface
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- New dice
function Dice:new(x, y, diceType)
    local dice = display.newGroup()
    dice.selected = false  -- Initial create sends an extra "tap" event
                           -- to the dice.  Soooooo, a bit of a bug here,
                           -- in that the dice is set initially to NOT being
                           -- selected, however, the extra "tap" WILL select it.

    dice.recycle = false -- recycle dice status flag
    dice.sides = diceType.sides
    dice.randomRotation = diceType.randomRotation
    dice.selectColor = diceType.selectColor
    dice.x = x; dice.y = y

    dice.sprite = display.newSprite(diceType.sheet, diceType.sequence)
    dice.sprite:setSequence("diceFinal")
    dice.sprite:setFrame(math.random (dice.sides))
    dice.sprite.rotation = math.random(dice.randomRotation[1], dice.randomRotation[2])
    dice:insert(dice.sprite)

    dice.xScale = 0.5; dice.yScale = 0.5
    transition.to(dice, { time=500, xScale=1.0, yScale=1.0, transition=easingx.easeOutElastic })        
    physics.addBody(dice, { density=0.2, friction=0.3, bounce=0.1, shape=diceType.shape })
    dice.linearDamping = 3
    dice.angularDamping = 5
    local deleteButton = newDeleteButton(40, 40)
    dice:insert(deleteButton)

    --------------------------------------------------------------------------
    -- Public Dice Interface
    --------------------------------------------------------------------------

    --------------------------------------------------------------------------
    -- Sprite sequence to rolling dice
    function dice:rollSequence()
        self.sprite:setSequence("diceRoll")
    end

    --------------------------------------------------------------------------
    -- Sprite sequence to final dice
    function dice:finalSequence()
        self.sprite:setSequence("diceFinal")
    end

    --------------------------------------------------------------------------
    -- Select / Deselect dice
    function dice:toggleSelect()
        self.xScale = 0.5; self.yScale = 0.5
        transition.to(self, { time=500, xScale=1.0, yScale=1.0, transition=easingx.easeOutElastic })        
        self.selected = not self.selected
        if (self.selected) then
            self.sprite:setFillColor(self.selectColor[1], self.selectColor[2], self.selectColor[3], 255)
        else
            self.sprite:setFillColor(255, 255, 255)
        end
    end

    --------------------------------------------------------------------------
    -- recycle flag
    function dice:setRecycle(r)
        self.recycle = r
    end
    function dice:isRecycle()
        return self.recycle
    end

    --------------------------------------------------------------------------
    -- Dice selected? true/false
    function dice:isSelected()
        return self.selected
    end

    return dice
end

return Dice
