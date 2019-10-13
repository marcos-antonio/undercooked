-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local joystick = require("joystick")
local gameloop = require("gameloop")
local spaceship = require("spaceship")
local objPanela = require("panela")
local objDish = require("prato")

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local cooker, carnes, vegetais
local pan, dish
local mesaIngr, mesaCoz, mesaLouc, mesaPrat

function scene:create( event )

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newImageRect( 'backg.png', screenW, screenH )
	background.x, background.y = display.screenOriginX, display.screenOriginY
	-- local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0

	mesaIngr = display.newImageRect('mesa-ingr.png', 20, 100)
	mesaIngr.x, mesaIngr.y = display.actualContentWidth - 55, display.actualContentHeight / 2

	mesaCoz = display.newImageRect("mesa-coz.png", 100, 20)
	mesaCoz.x, mesaCoz.y = display.contentWidth / 4, display.actualContentHeight - 10

	mesaPrat = display.newImageRect("mesa-coz.png", 100, 20)
	mesaPrat.x, mesaPrat.y = (display.contentWidth / 4) * 3, display.actualContentHeight - 10

	mesaLouc = display.newImageRect('mesa-louc.png', 20, 100)
	mesaLouc.x, mesaLouc.y = 0 - 35, display.actualContentHeight / 2

	carnes = criarCarne(display.actualContentWidth - 55, (display.actualContentHeight / 2) + 30)

	vegetais = criarVegetal(display.actualContentWidth - 55, (display.actualContentHeight / 2) - 30)

	pan = createPan()

	dish = Dish:new((display.contentWidth / 4) * 3 + 20, display.actualContentHeight - 10)

	local button = display.newCircle(7 * display.contentWidth / 8, 6 * display.contentHeight / 8, display.contentWidth/15)

	local stick = joystick.new(display.contentWidth / 8, 6 * display.contentHeight / 8)
	cooker = spaceship.new(0, 0, 0.01)
	stick:init()
	sceneGroup:insert( background )
	sceneGroup:insert( mesaIngr )
	sceneGroup:insert( mesaCoz )
	sceneGroup:insert( mesaLouc )
	sceneGroup:insert( cooker:getDisplayObject() )
	gameloop:init()

	button:addEventListener( "touch", button_pressed );
end

function runGL()
	cooker:run()
end

function criarVegetal(x, y)
	vegetal = display.newCircle(x, y, 10)
	vegetal:setFillColor(0, 1, 0)
	return vegetal;
end

function criarCarne(x, y)
	carne = display.newCircle(x, y, 10)
	carne:setFillColor(1, 0, 0)
	return carne;
end

function createPan(x, y)
	return objPanela.new(display.contentWidth / 4 + 20, display.actualContentHeight - 10)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		Runtime:addEventListener("enterFrame", runGL)
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end

function areObjectsCloseToEachOther(leftiest, rightiest)
	return (rightiest.x - leftiest.x) < 40 and (rightiest.y - leftiest.y) < 40
end

function getObjectCoordinates(obj)
	return {x = obj:getX(), y = obj:getY()}
end

function canPickupIngr(coordinates, ingr)
	return areObjectsCloseToEachOther(coordinates, ingr)
end

function canPickupPan(coordinates, pan)
	return areObjectsCloseToEachOther(coordinates, getObjectCoordinates(pan)) and pan:isPickable()
end


function canPickupDish(dish)
	return areObjectsCloseToEachOther(getObjectCoordinates(cooker), getObjectCoordinates(dish)) and dish:isPickable()
end

function button_pressed(event)
	if (event.phase == 'ended') then
		if(cooker:isCarryingObject()) then
			whenCarryingObject()
		else
			whenNotCarryingObject()
		end
	end
end

function canDestroyCarryingObject()
	if (cooker.getCarryingObject().getType == nil) then
		return (areObjectsCloseToEachOther(getObjectCoordinates(cooker), carnes) or areObjectsCloseToEachOther(getObjectCoordinates(cooker), vegetais))
	end
	return false
end

function canPutPanIngredientsOnDish(pan, dish)
	if (not (cooker.getCarryingObject().getType == nil) and cooker.getCarryingObject().getType() == 1
		and areObjectsCloseToEachOther(getObjectCoordinates(pan), getObjectCoordinates(dish))) then
		return true
	end
	return false
end

function canPutIngredientOnPan(pan)
	return cooker.getCarryingObject().getType == nil and areObjectsCloseToEachOther(getObjectCoordinates(cooker), getObjectCoordinates(pan)) and pan:podeAdicionarIngrediente()
end

function whenCarryingObject(event)
	if (canDestroyCarryingObject()) then
		cooker:destroyCarriedObject()
	elseif(canPutPanIngredientsOnDish(pan, dish)) then
		dish:setIngredients(pan:getIngredients())
		pan:setIngredients({})
		cooker:destroyCarriedObject()
		pan:hide()
		pan = createPan()
	elseif (canPutIngredientOnPan(pan)) then
		local cObj = cooker:getCarryingObject()
		cooker:setCarriedObject(nil)
		pan:adicionarIngrediente(cObj)
	end
end


function whenNotCarryingObject(event)
	local cookerCoordinates = getObjectCoordinates(cooker)
	if (canPickupIngr(cookerCoordinates, carnes)) then
		local newIngr = criarCarne(cooker:getX(), cooker:getY())
		cooker:setCarriedObject(newIngr)
	elseif (canPickupIngr(cookerCoordinates, vegetais)) then
		local newIngr = criarVegetal(cooker:getX(), cooker:getY())
		cooker:setCarriedObject(newIngr)
	elseif (canPickupPan(cookerCoordinates, pan)) then
		cooker:setCarriedObject(pan)
	elseif(canPickupDish(dish)) then
		cooker:setCarriedObject(dish)
	end

end


function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene