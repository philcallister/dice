------------------------------------------------------------------------------
-- Dragon Dice
-- Copyright (c) 2012 by Phil Callister. All Rights Reserved.
--
-- DiceRoll.lua => Roll the dice.
--
require("scripts.corona.wall")
local gameUI = require("scripts.corona.gameUI")
local physics = require("physics")
local widget = require("widget")

local dice = require("scripts.dice.Dice")
require("scripts.dice.Dice4")
require("scripts.dice.Dice6")

local bg = display.newImage("images/background.png", true)
bg.x = display.contentWidth / 2
bg.y = display.contentHeight / 2

physics.start()
physics.setGravity( 0, 0 ) -- no gravity in any direction

local popSound = audio.loadSound("audio/pop.wav")

-- current dice on display
local diceAll = {}
local recycle = nil

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
            local vx = math.random(-4000, 4000)
            local vy = math.random(-4000, 4000)
            d:setLinearVelocity(vx, vy)
            d:rollSequence()                      
            d.sprite:play()
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
            or { default={ 255, 255, 255, 255 }, over={ 217, 217, 217, 255 } },
        fontSize = 36
    }
    button.x = x
    button.y = y
    return button
end
newRollDice("Roll Dice", false, display.contentCenterX, 900)

--------------------------------------------------------------------------
-- Recycle dice
local function recycleDice(x, y)
    recycle = display.newImage("images/recycle.png", true)
    recycle.x = x; recycle.y = y
end
recycleDice(display.contentCenterX, display.contentCenterY)

------------------------------------------------------------------------------
-- point x1, y1 within x2 + length, y2 + length? 
local function hitTest(x1, y1, x2, y2, length)
    if ((x1 > x2 - length and x1 < x2 + length) and
        (y1 > y2 - length and y1 < y2 + length)) then
        return true
    end
    return false
end

------------------------------------------------------------------------------
-- drag the dice around
local function dragDice(event)
    local d = event.target
    local phase = event.phase
    if (phase == "began") then
        if (hitTest(d.x, d.y, display.contentCenterX, display.contentCenterY, 50)) then
            d:setRecycle(true) -- already in recycle area. can't recycle until moved out
        else
            d:setRecycle(false) -- out of recycle area. ready to recycle
        end
    elseif (phase == "moved") then
        if ( not hitTest(d.x, d.y, display.contentCenterX, display.contentCenterY, 50)) then
            d:setRecycle(false) -- move was outside recycle area
        end
    elseif (phase == "ended") then
        -- recycle the dice
        if (hitTest(d.x, d.y, display.contentCenterX, display.contentCenterY, 50) and
            d:isRecycle() == false) then
            for i = 1, #diceAll do
                if (d == diceAll[i]) then
                    -- animate recycler
                    recycle.rotation = 0
                    transition.to( recycle, { time=1000, rotation=-360 } )
                    -- dice gone!
                    d:removeSelf() -- @@@@@ Remove goodies on dice first??
                    table.remove(diceAll, i)
                end
            end
        elseif (d:isSelected()) then
            local vx, vy = d:getLinearVelocity()
            -- start the roll
            if (math.abs(vx) > 400 or math.abs(vy) > 400) then
                d:rollSequence()
                d.sprite:play()
            end
        end
    end
    return gameUI.dragBody(event)
end

------------------------------------------------------------------------------
-- tapped dice -- toggle dice selection
local function tapDice(event)
    local d = event.target
    d:toggleSelect()
    audio.play(popSound)
    return true
end

------------------------------------------------------------------------------
-- touch display -- create dice
local function touchDisplay(event)    
    if (event.phase == "ended") then
        -- add new dice
        -- @@@@@ TODO: for now just random on available dice
        local i = math.random(1,2)
        local t = nil
        if (i == 1) then
            t = Dice4
        else
            t = Dice6
        end
        local d = dice:new(event.x, event.y, t)

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
        if (d.sprite.isPlaying) then
            local vx, vy = d:getLinearVelocity()
            if (math.abs(vx) < 50 and math.abs(vy) < 50) then
                d:finalSequence()                      
                d.sprite:setFrame(math.random (d.sides))
                d.sprite.rotation = math.random(d.randomRotation[1], d.randomRotation[2])
                d.sprite:pause()
            end
        end
    end
end

Runtime:addEventListener("enterFrame", enterFrame)
Runtime:addEventListener("touch", touchDisplay)
