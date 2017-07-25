local Fonts = require "../assets/fonts"
require "../components/board"
require "../components/food"

local Snake = {
	score = 0,
	tick = 0,
	ticked = false
}

function Snake:new (startpos, length, direction, speed)
	local matrix = {}

	for i=1,Board.width + 1 do
		matrix[i] = {}
		for j=1,Board.height + 1 do
			matrix[i][j] = {x = 0, y = 0}
		end
	end

	matrix[startpos.x][startpos.y] = {x = startpos.x + direction.x, y = startpos.y + direction.y}

	o = {
		head = {x = startpos.x, y = startpos.y},
		tail = {x = startpos.x, y = startpos.y},
		matrix = matrix,
		foodTicks = length,
		direction = direction,
		speed = speed
	}

	setmetatable(o, self)
	self.__index = self
	return o
end

function Snake:update (dt)
	self.tick = self.tick + dt
	while self.tick >= self.speed do
		self.ticked = true
		self:move()
		self.tick = self.tick - self.speed
	end
end

function Snake:move ()
	if self.head.x > 1 and self.head.y > 1 and self.head.x < Board.width and self.head.y < Board.height then
		local temp = {x = self.head.x, y = self.head.y}
		self.head.x = self.head.x + self.direction.x
		self.head.y = self.head.y + self.direction.y
		if self.matrix[self.head.x][self.head.y].x + self.matrix[self.head.x][self.head.y].y > 0 then
			gameOver()	-- Hit yourself
		else
			self.matrix[temp.x][temp.y] = {x = self.head.x, y = self.head.y}
			self.matrix[self.head.x][self.head.y] = {x = 1, y = 1}
			
			if self.head.x == Food.x and self.head.y == Food.y then
				local randShare = math.random(1, 4)
				self.foodTicks = self.foodTicks + 8 + randShare
				self.score = self.score + 8 + randShare
				Food.replace()
			end

		end
	else
		gameOver() -- Hit a wall
	end

	if self.foodTicks <= 0 then -- Remove tail
		local newTail = {x = self.matrix[self.tail.x][self.tail.y].x, y = self.matrix[self.tail.x][self.tail.y].y}
		self.matrix[self.tail.x][self.tail.y].x = 0
		self.matrix[self.tail.x][self.tail.y].y = 0
		self.tail.x = newTail.x
		self.tail.y = newTail.y
		self.foodTicks = 0
	else
		self.foodTicks = self.foodTicks - 1
	end
end

function Snake:draw ()
	love.graphics.setColor(255, 255, 255)
	for x=2,Board.width-1 do
		for y=2,Board.height-1 do
			if self.matrix[x][y].x + self.matrix[x][y].y > 0 then
				love.graphics.rectangle(
					'fill', Board.xoffset + (x-1)*Board.blocksize + 1,
					Board.yoffset + (y-1)*Board.blocksize + 1,
					Board.blocksize - 1,
					Board.blocksize - 1)
			end
		end
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(Fonts.smFont)
	love.graphics.print(self.score, Board.xoffset + 2*Board.blocksize, Board.yoffset + 2*Board.blocksize)
end

function Snake:rotate(code)
	if self.direction.x == 1 then
		if code == 'down' then
			self:rotateCw()
		elseif code == 'up' then
			self:rotateCcw()
		end
	elseif self.direction.x == -1 then
		if code == 'down' then
			self:rotateCcw()
		elseif code == 'up' then
			self:rotateCw()
		end
	elseif self.direction.y == 1 then
		if code == 'left' then
			self:rotateCw()
		elseif code == 'right' then
			self:rotateCcw()
		end
	elseif self.direction.y == -1 then
		if code == 'left' then
			self:rotateCcw()
		elseif code == 'right' then
			self:rotateCw()
		end
	end
end

function Snake:rotateCcw()
	if self.ticked then
		local temp = self.direction.x
		self.direction.x = self.direction.y
		self.direction.y = -temp
		self.ticked = false
	end
end

function Snake:rotateCw()
	if self.ticked then
		local temp = self.direction.x
		self.direction.x = -self.direction.y
		self.direction.y = temp
		self.ticked = false
	end
end

function gameOver ()
	GameState = 'game_over'
end

return Snake
