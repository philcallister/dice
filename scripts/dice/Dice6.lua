Dice6 = {}

Dice6.sequence = { {name="diceRoll", start=1, count=24, time=500},
                   {name="diceFinal", start=25, count=6, time=0} }
Dice6.options = {
    -- Required params
    width = 130, --130 (65)
    height = 130, -- 130 (65)
    numFrames = 30,
    -- content scaling
    sheetContentWidth = 3900, -- 3900 (1950)
    sheetContentHeight = 130 -- 130 (65)
}
Dice6.sheet = graphics.newImageSheet( "sprites/d6/sprite.png", Dice6.options )
Dice6.shape = { -36,-36, 36,-36, 36,36, -36,36 }
Dice6.selectColor = {255, 59, 20}
Dice6.randomRotation = {1, 360}
Dice6.sides = 6

return Dice6
