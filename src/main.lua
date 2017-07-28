require "components/board"
require "components/food"
local Snake = require "components/snake"
local Fonts = require "assets/fonts"
local PauseButton = require "components/pausebtn"

GameState = 'not_started'
Players = {}


local touchStart = {x = nil, y = nil}
local pauseBtn = nil

function love.load ()
	math.randomseed(os.time())
	Board.init()
end

function love.update (dt)
	if GameState == 'playing' then
		for i,p in ipairs(Players) do
			p:update(dt)
		end
	end
end

function startGame ()
	Board.init()
	Players[1] = Snake:new({x = 20, y = 20}, 5, {x = 1, y = 0}, 0.1)
	Food.replace()
	GameState = 'playing'
	pauseBtn = PauseButton:new((Board.width-2) * Board.blocksize - 20, Board.blocksize * 2, 18)
end

function love.keypressed (key, scancode, isrepeat)
	if GameState ~= 'playing' then
		if key == 'escape' then
			love.event.quit(0)
		end
	end

	if GameState == 'not_started' or GameState == 'game_over' then
		if key == 'space' then
			startGame()
		end
	elseif GameState == 'paused' then
		if key == 'space' then
			GameState = 'playing'
		end
	elseif GameState == 'playing' then
		Players[1]:rotate(scancode)
		if key == 'escape' then
			GameState = 'paused'
		end
	end
end

function love.mousereleased (x, y, btn, istouch)
	if GameState == 'not_started' or GameState == 'game_over' then
		startGame()
	elseif GameState == 'paused' then
		GameState = 'playing'
	elseif GameState == 'playing' then
		local dx = touchStart.x - x
		local dy = touchStart.y - y

		if math.abs(dx) > 10 or math.abs(dy) > 10 then
			local code = ''
			if math.abs(dx) > math.abs(dy) then --Horizontal
				if dx > 0 then
					code = 'left'
				else
					code = 'right'
				end
			else -- Vertical
				if dy > 0 then
					code = 'up'
				else
					code = 'down'
				end
			end
			Players[1]:rotate(code)
		end
		pauseBtn:mousereleased(x, y, btn, istouch)
	end
end

function love.mousepressed (x, y, btn, istouch)
	touchStart.x = x
	touchStart.y = y
end

function drawTextScreen (upper, middle, lower)
	love.graphics.setFont(Fonts.lgFont)
	love.graphics.printf(upper, 0, love.graphics.getHeight() / 3, love.graphics.getWidth(), 'center')
	love.graphics.setFont(Fonts.smFont)
	love.graphics.printf(middle, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 'center')
	love.graphics.printf(lower, 0, love.graphics.getHeight() * 2 / 3, love.graphics.getWidth(), 'center')
end

function love.draw ()
	if GameState == 'not_started' then
		drawTextScreen('Snake', '', 'Tap to begin')
	elseif GameState == 'playing' then
		Board.draw()
		Food.draw()
		pauseBtn:draw()
		for i,p in ipairs(Players) do
			p:draw()
		end
	elseif GameState == 'paused' then
		drawTextScreen('Pause', Players[1].score..' points', 'Tap to continue')
	elseif GameState == 'game_over' then
		drawTextScreen('Game Over', Players[1].score..' points', 'Tap to restart')
	end
end
