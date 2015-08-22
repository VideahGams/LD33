-- This code is licensed under the MIT Open Source License.

-- Copyright (c) 2015 Ruairidh Carmichael - ruairidhcarmichael@live.co.uk

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

local Player = class('Player')

function Player:initialize(x, y, w, h)

	self.width = w
	self.height = h

	self.x = (topScreenWidth / 2) - (self.width / 2)
	self.y = (topScreenHeight / 2) - (self.height / 2)

	self.speed = 200
	self.direction = 'up'

	print('Created player.')

end

function Player:update(dt)

	if love.keyboard.isDown('cpadleft') or love.keyboard.isDown('dleft') then

		game.offsetX = game.offsetX - (self.speed * dt)

	end

	if love.keyboard.isDown('cpadright') or love.keyboard.isDown('dright') then

		game.offsetY = game.offsetY + (self.speed * dt)

	end

end

function Player:draw()

	love.graphics.setColor(155, 0, 0, 255)

	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

end

return Player