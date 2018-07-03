local w, h, x, y

-- Map the value 's' range '[a1-a2]' to a value between '[b1-b2]'
-- https://rosettacode.org/wiki/Map_range#lua
function mapRange( a1, a2, b1, b2, s )
    return b1 + (s-a1)*(b2-b1)/(a2-a1)
end

function drawPoint(canvas, x, y)
    love.graphics.setCanvas(canvas)
        love.graphics.setColor(0.42352941176471, 0.70196078431373, 
                                                    0.36078431372549)
        love.graphics.circle('fill', x, y, 1)
        love.graphics.setColor(1,1,1)
    love.graphics.setCanvas()
end

--[[ Calculate the next point using the next table
|---------------------------------------------------------------------------|
|ƒ1|  0	  |  0   |  0   | 0.16| 0| 0   | 0.01| Stem                         |
|---------------------------------------------------------------------------|
|ƒ2|  0.85|  0.04| −0.04| 0.85| 0| 1.60| 0.85| Successively smaller leaflets|
|---------------------------------------------------------------------------|
|ƒ3|  0.20| −0.26|  0.23| 0.22| 0| 1.60| 0.07| Largest left-hand leaflet    |
|---------------------------------------------------------------------------|
|ƒ4| −0.15|  0.28|  0.26| 0.24| 0| 0.44| 0.07| Largest right-hand leaflet   |
|---------------------------------------------------------------------------|
]]--
function nextPoint(x1, y1)
    local x2, y2
    local r = love.math.random()
    --ƒ1
    if r < 0.1 then
        x2 = 0
        y2 = 0.16 * y1
    --ƒ2
    elseif r < 0.86 then
        x2 =  0.85 * x1 + 0.04 * y1
        y2 = -0.04 * x1 + 0.85 * y1 + 1.6
    --ƒ3
    elseif r < 0.93 then
        x2 = 0.20 * x1 - 0.26 * y1
        y2 = 0.23 * x1 + 0.22 * y1 + 1.6
    --ƒ4
    else 
        x2 = -0.15 * x1 + 0.28 * y1
        y2 =  0.26 * x1 + 0.24 * y1 + 0.44
    end
    return x2, y2
end

function love.load()
    -- Get window size
    w, h = love.window.getMode()
    -- Create new canvas
    frac = love.graphics.newCanvas(w, h)
    x,y = 0, 0
end

function love.update()
    for i=0, 100 do
        x, y = nextPoint(x, y)
        local px = mapRange(-2.1820, 2.6558, 0, w, x)
        local py = mapRange(0, 9.9983, h, 0, y)
        drawPoint(frac, px, py)
    end
end

function love.draw()
    love.graphics.draw(frac, 0, 0)
end
