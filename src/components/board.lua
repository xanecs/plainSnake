Board = {
	width = 0,
	height = 0,
	xoffset = 0,
	yoffset = 0,
	blocksize = 0
}

function Board.init()
	local w, h = love.window.getDesktopDimensions()
	love.window.setMode(w, h, {fullscreen = true, fullscreentype = "exclusive"})
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	
	Board.blocksize = h / 50
	Board.width = math.floor(w / Board.blocksize)
	Board.height = math.floor(h / Board.blocksize)
	Board.xoffset = math.floor((w - Board.width*Board.blocksize) / 2)
	Board.yoffset = math.floor((h - Board.height*Board.blocksize) / 2)
end

function Board.draw()
	love.graphics.setColor(48, 48, 48)
	love.graphics.setLineWidth(math.floor(1.8*Board.blocksize))
	love.graphics.rectangle('line', Board.xoffset, Board.yoffset, Board.width * Board.blocksize, Board.height * Board.blocksize)
end

