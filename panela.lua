local panela = {}
local panela_mt = {__index = panela};

function panela.new(_x, _y)
    local newPanela = {}
    objPan = display.newRect(_x, _y, 20, 20)
    objPan:setFillColor(0.75)
    x, y = _x, _y

    ingredientes = {}

    return setmetatable( newPanela, panela_mt )
end

function panela:adicionarIngrediente(ingr)
    ingr.x = x
    ingr.y = y
    ingr.width = 5
    ingr.height = 5
    table.insert(ingredientes, ingr)
end

function panela:getX()
    return x
end
function panela:getY()
    return y
end



return panela