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
require("dish")
require("deliverybalcony")

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local cooker, carnes, vegetais
local pan, dish
local mesaIngr, mesaCoz, mesaPrat, balcony, score, sceneGroup
local blinkIngr, blinkCoz, blinkPrat, blinkBalc = true, false, false, false

function scene:create( event )

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	sceneGroup = self.view

	local backgroundMusic = audio.loadStream( "game.mp3" )
	audio.play( backgroundMusic, { channel=1, loops=-1 } )

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

	balcony = DeliveryBalcony:new()

	mesaIngr = display.newImageRect('mesa-ingr.png', 20, 100)
	mesaIngr.x, mesaIngr.y = display.actualContentWidth - 55, display.actualContentHeight / 2

	mesaCoz = display.newImageRect("mesa-coz.png", 100, 20)
	mesaCoz.x, mesaCoz.y = display.contentWidth / 4, display.actualContentHeight - 10

	mesaPrat = display.newImageRect("mesa-coz.png", 100, 20)
	mesaPrat.x, mesaPrat.y = (display.contentWidth / 4) * 3, display.actualContentHeight - 10

	carnes = criarCarne(display.actualContentWidth - 55, (display.actualContentHeight / 2) + 30)

	vegetais = criarVegetal(display.actualContentWidth - 55, (display.actualContentHeight / 2) - 30)

	pan = createPan()

	dish = Dish:new((display.contentWidth / 4) * 3 + 20, display.actualContentHeight - 10)

	local button = display.newCircle(7 * display.contentWidth / 8, 6 * display.contentHeight / 8, display.contentWidth/15)

	local stick = joystick.new(display.contentWidth / 8, 6 * display.contentHeight / 8)
	cooker = spaceship.new(display.contentCenterX, display.contentCenterY, 0.01)

	button:addEventListener( "touch", button_pressed );
	local countdown = display.newText( 60, 0, 20, native.systemFont, 40 );
	countdown:setFillColor( 0, 0, 0 )

	score = display.newText( 0, display.contentCenterX * 2, 20, native.systemFont, 40 );
	score:setFillColor( 0, 0, 0 )

	local tm = timer.performWithDelay(1000,
		function(event)
			local cd = event.source.params.obj
			if (tonumber(cd.text) <= 1) then
				composer.gotoScene('score', {effect = "fade", time = 200, params = { score = tonumber(score.text)}})
			else
				cd.text = cd.text - 1
			end
		end, 60)
	tm.params = {obj = countdown}

	startBlinking()

	stick:init()


	sceneGroup:insert( background )
	sceneGroup:insert( mesaIngr )
	sceneGroup:insert( mesaCoz )
	sceneGroup:insert( mesaPrat )
	sceneGroup:insert( balcony.balconyDisplay )
	sceneGroup:insert( stick.getStick() )
	sceneGroup:insert( stick.getShadow() )
	sceneGroup:insert( pan.getObj() )
	sceneGroup:insert( pan.getCounter() )
	sceneGroup:insert( button )
	sceneGroup:insert( carnes )
	sceneGroup:insert( vegetais )
	sceneGroup:insert( countdown )
	sceneGroup:insert( score )
	sceneGroup:insert( dish:getDisplay() )
	sceneGroup:insert( cooker:getDisplayObject() )
end

function startBlinking()
	timer.performWithDelay(250,
	function(event)
		if (blinkIngr and mesaIngr.alpha == 1) then
			mesaIngr.alpha = 0.50
		else
			mesaIngr.alpha = 1
		end

		if (blinkCoz and mesaCoz.alpha == 1) then
			mesaCoz.alpha = 0.50
		else
			mesaCoz.alpha = 1
		end

		if (blinkPrat and mesaPrat.alpha == 1) then
			mesaPrat.alpha = 0.50
		else
			mesaPrat.alpha = 1
		end

		if (blinkBalc and balcony:getDisplay().alpha == 1) then
			balcony:getDisplay().alpha = 0.50
		else
			balcony:getDisplay().alpha = 1
		end

	end, 0)
end

function runGL()
	cooker:run()
end

function increaseScore(value)
	score.text = tonumber(score.text) + value
end

function criarVegetal(x, y)
	vegetal = display.newImageRect('Apple.png', 16, 16)
	sceneGroup:insert(vegetal)
	vegetal.x = x
	vegetal.y = y
	return vegetal;
end

function criarCarne(x, y)
	carne = display.newImageRect('Bacon.png', 16, 16)
	sceneGroup:insert(carne)
	carne.x = x
	carne.y = y
	return carne;
end

function createPan(x, y)
	local objPan = objPanela.new(display.contentWidth / 4 + 20, display.actualContentHeight - 10)
	sceneGroup:insert(objPan.getObj())
	sceneGroup:insert(objPan.getCounter())
	return objPan
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
		audio.stop( 1 )
		physics.stop()
	elseif phase == "did" then
		Runtime:removeEventListener("enterFrame", runGL)
		composer.removeScene( "level1" )
		-- Called when the scene is now off screen
	end

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

function areObjectsCloseToEachOther(leftiest, rightiest)
	local xClose, yClose;
	if (rightiest.x > leftiest.x) then
		xClose = rightiest.x - leftiest.x < 40
	else
		xClose = leftiest.x - rightiest.x < 40
	end
	if (rightiest.x > leftiest.x) then
		yClose = rightiest.y - leftiest.y < 40
	else
		yClose = leftiest.y - rightiest.y < 40
	end

	return xClose and yClose
end

function getObjectCoordinates(obj)
	return {x = obj:getX(), y = obj:getY()}
end

function canDestroyCarryingObject()
	if (cooker.getCarryingObject().getType == nil) then
		return (areObjectsCloseToEachOther(getObjectCoordinates(cooker), carnes) or areObjectsCloseToEachOther(getObjectCoordinates(cooker), vegetais))
	end
	return false
end

function isPan(obj)
	return not (cooker.getCarryingObject().getType == nil) and cooker.getCarryingObject().getType() == 1
end

function isDish(obj)
	return not (cooker.getCarryingObject().getSelfType == nil) and cooker.getCarryingObject():getSelfType() == 0
end

function isIngr(obj)
	return not (cooker:getCarryingObject().getType) and not ((cooker:getCarryingObject().getSelfType))
end

function canPutPanIngredientsOnDish(pan, dish)
	return areObjectsCloseToEachOther(getObjectCoordinates(pan), getObjectCoordinates(dish))
end

function canPutIngredientOnPan(pan)
	return cooker.getCarryingObject().getType == nil and areObjectsCloseToEachOther(getObjectCoordinates(cooker), getObjectCoordinates(pan)) and pan:podeAdicionarIngrediente()
end

function canPutDishOnBalcony(dish)
	return areObjectsCloseToEachOther(getObjectCoordinates(dish), getObjectCoordinates(balcony)) and dish:isDeliverable()
end

function whenCarryingObject(event)
	if (canDestroyCarryingObject()) then
		cooker:destroyCarriedObject()
		blinkIngr = true
		blinkCoz = false
	elseif(isPan(cooker:getCarryingObject()) and canPutPanIngredientsOnDish(pan, dish)) then
		dish:setIngredients(pan:getIngredients())
		pan:setIngredients({})
		cooker:destroyCarriedObject()
		pan:hide()
		pan = createPan()
		blinkPrat = false
	elseif (isIngr(cooker:getCarryingObject()) and canPutIngredientOnPan(pan)) then
		local cObj = cooker:getCarryingObject()
		cooker:setCarriedObject(nil)
		pan:adicionarIngrediente(cObj)
		blinkCoz = false
	elseif (isDish(cooker:getCarryingObject()) and canPutDishOnBalcony(dish)) then
		blinkBalc = false
		cooker:setCarriedObject(nil)
		dish:setX(9000)
		dish:setY(9000)
		dish = Dish:new((display.contentWidth / 4) * 3 + 20, display.actualContentHeight - 10)
		sceneGroup:insert( dish:getDisplay() )
		increaseScore(5)
	end
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


function whenNotCarryingObject(event)
	local cookerCoordinates = getObjectCoordinates(cooker)
	if (canPickupIngr(cookerCoordinates, carnes)) then
		local newIngr = criarCarne(cooker:getX(), cooker:getY())
		cooker:setCarriedObject(newIngr)
		blinkIngr, blinkCoz = true, true
	elseif (canPickupIngr(cookerCoordinates, vegetais)) then
		local newIngr = criarVegetal(cooker:getX(), cooker:getY())
		cooker:setCarriedObject(newIngr)
		blinkIngr, blinkCoz = true, true
	elseif (canPickupPan(cookerCoordinates, pan)) then
		cooker:setCarriedObject(pan)
		blinkPrat = true
	elseif(canPickupDish(dish)) then
		cooker:setCarriedObject(dish)
		blinkBalc = true
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