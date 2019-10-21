DeliveryBalcony = {
    dirtyDishes, balconyDisplay
}

function DeliveryBalcony:new()
    local obj = {}
    setmetatable(obj, self )
    self._index = self

    self.dishes = {}
    self.balconyDisplay = display.newImageRect('balcony.png', 100, 20)
	self.balconyDisplay.x, self.balconyDisplay.y = (display.contentWidth / 4) * 2, 0 + 10

    return self
end

function DeliveryBalcony:deliverDish(dish)
    local tm = timer.performWithDelay(2000,
         function (event)
            local obj = event.source.params.obj
            obj:hideDish(dish)
         end )
    tm.params = { obj = self, dish = dish }
end

function DeliveryBalcony:hideDish(dish)
    dish:setX(9000)
    dish:setY(9000)
end

function DeliveryBalcony:getX()
    return self.balconyDisplay.x
end

function DeliveryBalcony:getY()
    return self.balconyDisplay.y
end

