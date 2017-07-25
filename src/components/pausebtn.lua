require "../components/board"

local PauseButton = {
	x = 0,
	y = 0,
	size = 20
}

function PauseButton:new (x, y, size)
	o = {
		x = x,
		y = y,
		size = size
	}

	setmetatable(o, self)
	self.__index = self
	return o
end

function PauseButton:draw ()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', self.x + Board.xoffset, self.y + Board.yoffset, self.size / 3, self.size)
	love.graphics.rectangle('fill', self.x + Board.xoffset + self.size * 2 / 3, self.y + Board.yoffset, self.size / 3, self.size)
end	

function PauseButton:mousereleased (x, y, btn, istouch)
	if x >= self.x + Board.xoffset and y >= self.y + Board.yoffset and x <= self.x + Board.xoffset + self.size and y <= self.y + Board.yoffset + self.size then
		GameState = 'paused'
	end
end

return PauseButton
