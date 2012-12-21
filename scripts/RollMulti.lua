------------------------------------------------------------------------------
-- Dragon Dice
-- Copyright (c) 2012 by Phil Callister. All Rights Reserved.
--
-- RollMulti.lua => Multi-touch roll on devices that support it.
--
require("scripts.corona.wall")
local gameUI = require("scripts.corona.gameUI")
local dice = require("scripts.Dice")
local physics = require("physics")

physics.start()
physics.setGravity( 0, 0 ) -- no gravity in any direction

-- add walls so dice can bounce
local walls = display.newGroup()
newWall{ name="left", parent=walls }
newWall{ name="right", parent=walls }
newWall{ name="top", parent=walls }
newWall{ name="bottom", parent=walls }

-- current dice on display
local diceAll = {}

------------------------------------------------------------------------------
-- drag the dice around -- multi-touch only
local function dragDice(event)
    local drag = event.target
    local phase = event.phase

    if (phase == "ended") then
        local vx, vy = body:getLinearVelocity()
        -- start the roll
        if (math.abs(vx) > 400 or math.abs(vy) > 400) then
            body:setSequence( "diceRoll" )
            body:setFrame(math.random (6))
            body:play()
        end
    end
    return gameUI.dragBody(event)
end

------------------------------------------------------------------------------
-- touch display -- create dice
local function touchDisplay(event)    
    if (event.phase == "ended") then
        local d = dice:new(event.x, event.y)
        d:addEventListener("touch", dragDice)
        table.insert(diceAll, d)
    end
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

Runtime:addEventListener( "enterFrame", enterFrame )
Runtime:addEventListener("touch", touchDisplay)
