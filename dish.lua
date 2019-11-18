
Dish = {
    dishDispl, ingredients, x, y, objType
}

function Dish:new(_x, _y)
    local obj = {}
    setmetatable(obj, self )
    self._index = self

    self.objType = 0
    self.ingredients = {}
    self.dishDispl = display.newRect(_x, _y, 20, 20)
    self.dishDispl:setFillColor(1)
    self.x, self.y = _x, _y
    return self
end

function Dish:isPickable()
    return table.getn(self.ingredients) > 0
end

function Dish:setIngredients(_ingredients)
    self.ingredients = _ingredients
    for k, v in pairs(self.ingredients) do
        v.x = self.x
        v.y = self.y + 10
    end
end

function Dish:getNumberOfCarriedIngredients()
    return table.getn(self.ingredients)
end

function Dish:getIngredients()
    return self.ingredients
end

function Dish:getSelfType()
    return self.objType
end

function Dish:getDisplay()
    return self.dishDispl
end

function Dish:getX()
    return self.dishDispl.x
end

function Dish:getY()
    return self.dishDispl.y
end

function Dish:setX(_x)
    self.dishDispl.x = _x
    Dish:setXOnIngredients(_x)
end

function Dish:setY(_y)
    self.dishDispl.y = _y
    Dish:setYOnIngredients(_y)
end

function Dish:setXOnIngredients(_x)
    for k, v in pairs(self.ingredients) do
        v.x = _x
    end
end
function Dish:setYOnIngredients(_y)
    for k, v in pairs(self.ingredients) do
        v.y = _y
    end
end

function Dish:isDeliverable()
    return table.getn(self.ingredients) > 0
end