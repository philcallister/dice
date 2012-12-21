------------------------------------------------------------------------------
-- Dragon Dice
-- Copyright (c) 2012 by Phil Callister. All Rights Reserved.
--
-- RollStandard.lua => Roll on devices that don't support multi-touch.
--
require("scripts.corona.wall")
local gameUI = require("scripts.corona.gameUI")
local dice = require("scripts.Dice")
local physics = require("physics")
local widget = require("widget")

local bg = display.newImage("images/background.png", true)
bg.x = display.contentWidth / 2
bg.y = display.contentHeight / 2

physics.start()
physics.setGravity( 0, 0 ) -- no gravity in any direction

local popSound = audio.loadSound("audio/pop.wav")

-- current dice on display
local diceAll = {}

-- add walls so dice can bounce
local walls = display.newGroup()
newWall{ name="left", parent=walls }
newWall{ name="right", parent=walls }
newWall{ name="top", parent=walls }
newWall{ name="bottom", parent=walls }

--------------------------------------------------------------------------
-- Create "Roll Dice" button and roll 'em!
local function releaseRollButton()
    for i = 1, #diceAll do
        local d = diceAll[i]
        -- start each dice rolling if selected
        if(d:isSelected()) then
            local vx = math.random(-1000, 1000)
            local vy = math.random(-1000, 1000)
            d:setLinearVelocity(vx, vy)
            d:rollSequence()                      
            d:play()
        end
    end
    return true
end

local function newRollDice(label, selected, x, y)
    local button = widget.newButton
    {
        default = selected and "images/dice-text-over.png" or "images/dice-text.png",
        over = "images/dice-text-over.png",
        onRelease = releaseRollButton,
        label = label,
        labelColor = selected 
            and { default={ 217, 217, 217 }, over={ 217, 217, 217, 255 } } 
            or { default={ 255, 255, 255, 255 }, over={ 217, 217, 217, 255 } } ,
        fontSize = 36
    }
    button.x = x
    button.y = y
    return button
end
newRollDice("Roll Dice", false, display.contentCenterX, 900)

------------------------------------------------------------------------------
-- drag the dice around
local function dragDice(event)
    return gameUI.dragBody(event)
end

------------------------------------------------------------------------------
-- tapped dice -- toggle dice selection
local function tapDice(event)
    local dice = event.target
    dice:toggleSelect()
    audio.play(popSound)
    return true
end

------------------------------------------------------------------------------
-- touch display -- create dice
local function touchDisplay(event)    
    if (event.phase == "ended") then
        -- add new dice
        local d = dice:new(event.x, event.y)
        d:addEventListener("touch", dragDice)
        d:addEventListener("tap", tapDice)
        table.insert(diceAll, d)

        -- we're here!
        audio.play(popSound)
    end
    return true
end

------------------------------------------------------------------------------
-- Entering current frame
local function enterFrame( event )
    for i = 1, #diceAll do
        local d = diceAll[i]
        if (d.isPlaying) then
            local vx, vy = d:getLinearVelocity()
            if (math.abs(vx) < 50 and math.abs(vy) < 50) then
                d:finalSequence()                      
                d:setFrame(math.random (6))
                d:pause()
            end
        end
    end
end

Runtime:addEventListener("enterFrame", enterFrame)
Runtime:addEventListener("touch", touchDisplay)
