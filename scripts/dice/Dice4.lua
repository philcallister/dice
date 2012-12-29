Dice4 = {}

Dice4.sequence = { {name="diceRoll", start=1, count=25, time=500},
                   {name="diceFinal", start=26, count=4, time=0} }
Dice4.options = {
    -- Required params
    width = 131,
    height = 127,
    numFrames = 29,
    -- content scaling
    sheetContentWidth = 3799,
    sheetContentHeight = 127
}
Dice4.sheet = graphics.newImageSheet( "sprites/d4/sprite.png", Dice4.options )
--Dice6.shape = { -36,-36, 36,-36, 36,36, -36,36 }
Dice4.selectColor = {8, 194, 255}
Dice4.randomRotation = {0, 0}
Dice4.sides = 4

return Dice4
