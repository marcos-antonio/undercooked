-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

audio.reserveChannels( 1 )

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()

	-- go to level1.lua scene
	composer.gotoScene( "level1", "fade", 500 )

	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	local backgroundMusic = audio.loadStream( "menu.mp3" )

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "ma.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY


	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="New Game",
		labelColor = { default={0}, over={128} },
		font="Advertising_Script_Bold.ttf",
		fontSize=28,
		width=154, height=40,
		textOnly=true,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentHeight - 125

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( playBtn )
	audio.play( backgroundMusic, { channel=1, loops=-1 } )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		audio.stop( 1 )
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene