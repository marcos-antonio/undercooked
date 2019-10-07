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

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local cooker, mesaIngr, mesaCoz, mesaLouc, carnes, vegetais, panela

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
	mesaCoz.x, mesaCoz.y = display.actualContentWidth / 2, display.actualContentHeight - 10

	mesaLouc = display.newImageRect('mesa-louc.png', 20, 100)
	mesaLouc.x, mesaLouc.y = 0 - 35, display.actualContentHeight / 2

	carnes = criarCarne(display.actualContentWidth - 55, (display.actualContentHeight / 2) + 30)

	vegetais = criarVegetal(display.actualContentWidth - 55, (display.actualContentHeight / 2) - 30)

	panela = objPanela.new(display.actualContentWidth / 2 + 20, display.actualContentHeight - 10)

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

function criarPanela(x, y)
	panela = display.newRect(x, y, 20, 20)
	panela:setFillColor(0.75)
	return panela
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

function getFUpCoordinates(obj)
	return {x = obj:getX(), y = obj:getY()}
end

function button_pressed(event)
	if (event.phase == 'ended') then
		cookerCoordinates = {x = cooker:getX(), y = cooker:getY()}
		if (cooker:isCarryingObject() and (areObjectsCloseToEachOther(cookerCoordinates, carnes) or areObjectsCloseToEachOther(cookerCoordinates, vegetais))) then
			cooker:destroyCarryingObject()
		end
		if (not cooker:isCarryingObject() and areObjectsCloseToEachOther(cookerCoordinates, carnes)) then
			newIngr = criarCarne(cooker:getX(), cooker:getY())
			cooker:carryObject(newIngr)
		elseif (not cooker:isCarryingObject() and areObjectsCloseToEachOther(cookerCoordinates, vegetais)) then
			newIngr = criarVegetal(cooker:getX(), cooker:getY())
			cooker:carryObject(newIngr)
		else
			if (cooker:isCarryingObject() and areObjectsCloseToEachOther(cookerCoordinates, getFUpCoordinates(panela)) and panela:podeAdicionarIngrediente()) then
				cObj = cooker:getCarryingObject()
				cooker:carryObject(nil)
				panela:adicionarIngrediente(cObj)
			end
		end
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