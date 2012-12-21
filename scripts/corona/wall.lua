--[[
    Description:
        Provides physics walls for the edge of the screen.

    Params:
        .name = left, right, top, bottom
        .parent

    Returns:
        A wall.
]]--
function newWall( params )
    local group = display.newGroup()
    params.parent:insert( group )

    group.class = "wall"
    group.name = params.name
    group.params = params

    local width, height, x, y
    local sWidth = display.contentWidth
    local sHeight = display.contentHeight

    if (params.name == "left" or params.name == "right") then
        width, height = 2, sHeight
        y = sHeight/2
        if (params.name == "left") then
            x = 0
        else
            x = sWidth
        end
    elseif (params.name == "top" or params.name == "bottom") then
        width, height = sWidth, 2
        x = sWidth/2
        if (params.name == "top") then
            y = 0
        else
            y = sHeight
        end
    end

    group.rect = display.newRect( group, 0, 0, width, height )
    group.rect:setFillColor(49, 172, 66)
    group.rect.x, group.rect.y = x, y

    physics.addBody( group.rect, "static" )
end