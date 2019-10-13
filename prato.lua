
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

function Dish:setIngredients(_ingredients)
    self.ingredients = _ingredients
    for k, v in pairs(self.ingredients) do
        v.x = self.x
        v.y = self.y + 10
    end
end

function Dish:getIngredients()
    return self.ingredients
end

function Dish:getType()
    return self.objType
end

function Dish:getX()
    return self.dishDispl.x
end

function Dish:getY()
    return self.dishDispl.y
end