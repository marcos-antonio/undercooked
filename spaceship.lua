local joystick = require("joystick");
local physics = require("physics")

local spaceship = {};
local spaceship_mt = {__index = spaceship};

local spaceshipSprite = {
	type = "image",
	filename = "button.png"
}

local speed, maxSpeed, currentSpeed;
local width, lenght;
local accelerationRate;
local lastAngle;
local lastMagnitude;
local bullets = {};

local debug_speedText;
local debug_currentSpeed;
local debug_bulletNum;
local debug_spaceshipX, debug_spaceshipY;

local carriedObject;

function spaceship.new(_x, _y, _acceleration)
	local newSpaceship = {
		speed = 0;
	}
	speed = 0;
	currentSpeed = 0;
	maxSpeed = 5;
	accelerationRate = _acceleration;
	shootCooldown = 0;
	bulletNum = 0;
	bulletCount = 1;

	lastAngle = 0;
	lastMagnitude = 0;
	width = 154;
	lenght = 40;

	player = display.newRect( _x, _y, width, lenght )
	player.fill = spaceshipSprite;
	player:scale( 0.5, 0.5 )

	debug_speedText = display.newText("", 1200, 300, "Arial", 72)
	debug_currentSpeed = display.newText("", 500, 300, "Arial", 72)
	debug_spaceshipX = display.newText("", 1400, 500, "Arial", 72)
	debug_spaceshipY = display.newText("", 1400, 600, "Arial", 72)
	debug_bulletNum = display.newText("", 500, 900, "Arial", 72)

	return setmetatable( newSpaceship, spaceship_mt )
end

function spaceship:getDisplayObject(  )
	return player;
end

function spaceship:getX()
	return player.x;
end

function spaceship:getY(  )
	return player.y;
end

function spaceship:getSpeed(  )
	return speed;
end

function spaceship:getBullets(  )
	return bullets;
end

function spaceship:setX( _x )
	x = _x;
end

function spaceship:setY( _y )
	y = _y;
end

function spaceship:setIsShooting( _flag )
	isShooting = _flag;
end

function spaceship:setSpeed( _speed )
	speed = _speed;
end

function spaceship:setAcceleration( _acceleration )
	accelerationRate = _acceleration;
end

function spaceship:init(  )
	physics.start()
	physics.setGravity(0, 0)
end

function spaceship:carryObject(obj)
	carriedObject = obj
end

function spaceship:getCarryingObject()
	return carriedObject
end

function spaceship:isCarryingObject()
	return not not carriedObject
end

function spaceship:translate( _x, _y, _angle )
	if (not (player.x + _x > display.actualContentWidth - 40 or player.x + _x < -35)) then
		player.x = player.x + _x;
		if (carriedObject) then
			carriedObject.x = player.x + _x;
		end
	end
	if (not (player.y + _y > display.actualContentHeight or player.y + _y < 0)) then
		player.y = player.y + _y;
		if (carriedObject) then
			carriedObject.y = player.y + _y;
		end
	else
	end
	player.rotation = _angle
end

function spaceship:debug(  )
	debug_speedText.text = speed;
	debug_spaceshipX.text = player.x;
	debug_spaceshipY.text = player.y;
	debug_currentSpeed.text = currentSpeed;
  	debug_bulletNum.text = table.getn(bullets);
end

function spaceship:run( )
	if(joystick:isInUse() == false and (speed) > 0) then
		speed = 0;
		currentSpeed = speed;
		spaceship:translate( lastMagnitude * math.sin(math.rad(lastAngle)) * speed,
							-lastMagnitude * math.cos(math.rad(lastAngle)) * speed,
							 lastAngle);
	elseif(joystick:isInUse() == true) then
		-- if(speed < maxSpeed) then
		-- 	speed = speed + (accelerationRate * joystick:getMagnitude());
		-- end
		currentSpeed = joystick:getMagnitude() * maxSpeed;
		spaceship:translate( joystick:getMagnitude() * math.sin(math.rad(joystick:getAngle())) * currentSpeed,
							-joystick:getMagnitude() * math.cos(math.rad(joystick:getAngle())) * currentSpeed,
							 joystick:getAngle());
		lastAngle = joystick:getAngle();
		lastMagnitude = joystick:getMagnitude();
	end
end

return spaceship;