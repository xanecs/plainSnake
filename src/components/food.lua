require "../components/board"

Food = {
	x = 0,
	y = 0
}

function Food.replace()
	repeat
		Food.x = math.random(2, Board.width-2)
		Food.y = math.random(2, Board.height-2)
	until(Players[1].matrix[Food.x][Food.y].x + Players[1].matrix[Food.x][Food.y].y == 0 and not (Food.x > Board.width - 4 and Food.y < 4))
end

function Food.draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle(
		'fill', Board.xoffset + (Food.x-1)*Board.blocksize + 1,
		Board.yoffset + (Food.y-1)*Board.blocksize + 1,
		Board.blocksize - 1,
		Board.blocksize - 1)
end
