local panela = {}
local panela_mt = {__index = panela};

local objPan, tempoCozinhamento, timerAtual, ingredientes, textoTempoCoz,x, y
local limiteTempoCozinhamento = 2

function panela.new(_x, _y)
    local newPanela = {}
    objPan = display.newRect(_x, _y, 20, 20)
    objPan:setFillColor(0.75)
    x, y = _x, _y
    tempoCozinhamento = limiteTempoCozinhamento
    timerAtual = nil

    textoTempoCoz = display.newText(tempoCozinhamento, x, y - 30, native.systemFont, 20)
    textoTempoCoz:setFillColor( 0, 0, 0 )

    ingredientes = {}

    return setmetatable( newPanela, panela_mt )
end

local function dimunirTempoCozinhamentoClasse(event)
    local params = event.source.params
    params.f1()
    params.f2()
end

function panela:dimunirTempoCozinhamento()
    tempoCozinhamento = tempoCozinhamento - 1
    textoTempoCoz.text= tempoCozinhamento
end


function panela:adicionarIngrediente(ingr)
    ingr.x = x
    ingr.y = y
    ingr.width = 5
    ingr.height = 5
    table.insert(ingredientes, ingr)
    tempoCozinhamento = limiteTempoCozinhamento
    print(timerAtual)
    if (not (timerAtual == nil)) then
        timer.cancel(timerAtual)
    end
    panela:iniciarDimunirTempoCozinhamentoTimer()
end

function panela:iniciarDimunirTempoCozinhamentoTimer()
    if (tempoCozinhamento > 0 and tempoCozinhamento <= limiteTempoCozinhamento) then
        timerAtual = timer.performWithDelay( 1000, dimunirTempoCozinhamentoClasse)
        timerAtual.params = { f1 = panela.dimunirTempoCozinhamento, f2 = panela.iniciarDimunirTempoCozinhamentoTimer}
    end
end

function panela:podeAdicionarIngrediente()
    return table.getn(ingredientes) < 3 and tempoCozinhamento > 0
end

function panela:isPickable()
    return tempoCozinhamento == 0
end

function panela:getX()
    return x
end
function panela:getY()
    return y
end


function panela:setX(_x)
    objPan.x = _x
    panela:setXIngredients(_x)
end
function panela:setY(_y)
    objPan.y = _y
    panela:setYIngredients(_y)
end

function panela:setXIngredients(_x)
    for k, v in pairs(ingredientes) do
        v.x = _x
    end
end
function panela:setYIngredients(_y)
    for k, v in pairs(ingredientes) do
        v.y = _y
    end
end



return panela