-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )


local gameloop = require("gameloop")

gameloop.new();
gameloop:init();

-- local function gameLoop()
--     print('hm')
--     gameloop:run()
-- end

-- Runtime:addEventListener("enterFrame", gameLoop)