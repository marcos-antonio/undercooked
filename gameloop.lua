-- The game logic and loop
local joystick = require("joystick")
local physics = require("physics")


local gameloop = {};
local gameloop_mt = {};
local gameState;
local player;
local stick;
local fireBtn;

--[[  GameStates
	0 = not initialized
	1 = main menu
	2 = gameplay
	3 = pause menu
]]

local sceneGroup

function gameloop.new(view)
	local newGameloop = {
		gameState = 0;
    }
    sceneGroup = view
	return setmetatable( newGameloop, gameloop_mt );
end



-- Runs once to initialize the game
-- Runs everytime the game state changes
function gameloop:init()
    print('gameloop started')
end

-- Runs continously, but with different code for each different game state
function gameloop:run(event)
    print('gameloop run')
end

return gameloop;