------------------------------------------------------------------------------
-- Dragon Dice
-- Copyright (c) 2012 by Phil Callister. All Rights Reserved.
--
-- DicePicker.lua => Pick yer dice
--
local widget = require("widget")

local dice = require("scripts.dice.Dice")
require("scripts.dice.Dice4")
require("scripts.dice.Dice6")

DicePicker = {}


--------------------------------------------------------------------------
-- Private Methods
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- Create button to pick dice
local function _releaseDicePickButton(event)
    local d = dice:new(event.x, event.y, event.target.type)
    event.target.newDice(d)
    return true
end

local function _newDicePickButton(x, y, type, newDice)
    local button = widget.newButton
    {
        default = type.image,
        over = type.over,
        onRelease = _releaseDicePickButton
    }
    button.x = x
    button.y = y
    button.type = type
    button.newDice = newDice

    return button
end


--------------------------------------------------------------------------
-- Public Class Interface
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- New picker
function DicePicker:new(x, y, newDice)
    local picker = display.newGroup()
    picker.x = x; picker.y = y

    picker:insert(_newDicePickButton(-15, y, Dice4, newDice))
    picker:insert(_newDicePickButton(- 15, y + 100, Dice6, newDice))


    --------------------------------------------------------------------------
    -- Public Interface
    --------------------------------------------------------------------------

    --------------------------------------------------------------------------
    -- Sprite sequence to rolling dice
    function picker:xxx()
        print(">>>>> picker:xxx()")
    end

    return picker
end

return DicePicker