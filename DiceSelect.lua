local widget = require("widget")
local easingx = require("easingx")
 
DiceSelect = {}
function DiceSelect:new(x, y)

    local diceSelect = display.newGroup()
    diceSelect.diceTextButton = nil
    diceSelect.diceValue = ""
    diceSelect.selected = false
    diceSelect.diceButtonsGroup = display.newGroup()
    diceSelect.diceButtonsGroup.isVisible = false
    diceSelect:insert(diceSelect.diceButtonsGroup)
    diceSelect.diceButtons = {}


    local releaseTextButton = function(event)
        diceSelect:remove(diceSelect.diceTextButton)
        diceSelect.selected = not diceSelect.selected
        local label = (string.len(diceSelect.diceValue) > 0) and diceSelect.diceValue or "Select Dice"
        diceSelect.diceTextButton = diceSelect:newTextButton(label, diceSelect.selected,x,y)
        diceSelect:insert(diceSelect.diceTextButton)
        diceSelect.diceButtonsGroup.isVisible = diceSelect.selected
        if (diceSelect.selected) then
            diceSelect.diceButtonsGroup.xScale = 1.0
            diceSelect.diceButtonsGroup.yScale = 0.2
            transition.to(diceSelect.diceButtonsGroup, { time = 1000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
        end
    end

    local releaseDiceButton = function(event)
        if (string.len(diceSelect.diceValue) < 15 or event.target.id == "←") then
            local setLabel = true

            -- Back
            if (event.target.id == "←") then
                diceSelect.diceValue = string.sub(diceSelect.diceValue, 0, -2)
                if (string.len(diceSelect.diceValue) == 0) then
                    diceSelect.diceTextButton:setLabel("Select Dice")
                    setLabel = false
                end

            -- Clear
            elseif (event.target.id == "clr") then
                diceSelect.diceValue = ""
                diceSelect.diceTextButton:setLabel("Select Dice")
                setLabel = false

            -- Others
            else
                diceSelect.diceValue = diceSelect.diceValue .. event.target.id
            end

            if (setLabel) then
                diceSelect.diceTextButton:setLabel(diceSelect.diceValue)
            end
        end
    end

    function diceSelect:newTextButton(label, selected, x, y)
        local button = widget.newButton
        {
            default = selected and "dice-text-over.png" or "dice-text.png",
            over = "dice-text-over.png",
            onRelease = releaseTextButton,
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

    function diceSelect:newDiceButtons(group, buttons, x, y)
        
        -- Big Buttons
        local bigButtons = { "7", "8", "9",
                             "4", "5", "6",
                             "1", "2", "3",
                             "0", "d", "clr",
                             "L", "H", "←" }
        local count = 1
        for i = 1, 5 do
            for j = 1, 3 do
                local label = bigButtons[count]
                local useButton = "dice-button.png"
                local useButtonOver = "dice-button-over.png"
                if (count == 12 or count == 15) then
                    useButton = "dice-button-careful.png"
                    useButtonOver = "dice-button-careful-over.png"
                end
                buttons[count] = widget.newButton
                {
                    id = label,
                    default = useButton,
                    over = useButtonOver,
                    onRelease = releaseDiceButton,
                    label = label,
                    labelColor = { default={ 255, 255, 255 }, over={ 217, 217, 217, 255 } }, 
                    fontSize = 36
                }
                buttons[count].x = x - 312 + (j * 135)
                buttons[count].y = y - 2 + (i * 93)
                group:insert(buttons[count])
                count = count + 1
            end
        end

        -- Small Buttons
        local smallButtons = {"/", "x", "-", "+", "%"}
        for i = 1, 5 do
            local label = smallButtons[i]
            buttons[count] = widget.newButton
            {
                id = label,
                default = "dice-button-small.png",
                over = "dice-button-small-over.png",
                onRelease = releaseDiceButton,
                label = label,
                labelColor = { default={ 255, 255, 255 }, over={ 217, 217, 217, 255 } }, 
                fontSize = 36
            }
            buttons[count].x = x + 205
            buttons[count].y = y - 2 + (i * 93)
            group:insert(buttons[count])
            count = count + 1
        end
    end

    function diceSelect:dice()
    end

    diceSelect.diceTextButton = diceSelect:newTextButton("Select Dice", selected, x, y)
    diceSelect:insert(diceSelect.diceTextButton)
    diceSelect:newDiceButtons(diceSelect.diceButtonsGroup, diceSelect.diceButtons, x, y)

    return diceSelect

end
return DiceSelect