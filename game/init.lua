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

local game = {}

state = require 'game.state'
input = require 'game.input'

local menu = require 'game.menu'
local about = require 'game.about'
local gameover = require 'game.gameover'

local citizen = require 'game.entities.citizen'
happyImage = love.graphics.newImage('game/images/citizenHappy.png')
sadImage = love.graphics.newImage('game/images/citizenSad.png')

game.citizens = {}

function game.load()

	game.logo = love.graphics.newImage('game/images/logo.png')

	state.setState('menu')

	game.player = require 'game.entities.player':new(0, 0, 50, 50)

	menu.newOption('Play', function() state.setState('game') end)
	menu.newOption('About', function() state.setState('about') end)
	menu.newOption('Quit', function() love.event.quit() end)

	game.bgImage = love.graphics.newImage('game/images/bg.png')

	spawnTimer = 0

	game.jobs = 5

	game.totalThrown = 0

	game.maxeaten = 5

	print('Loaded "game"')

end

function game.update(dt)

	if state.isCurrentState('menu') then

		menu.update(dt)

	end

	if state.isCurrentState('game') then

		game.player:update(dt)

		for i, person in ipairs(game.citizens) do

			person:update(dt)

			if game.player:isTouching(person.x, person.y) and game.player.eaten < game.maxeaten and person.state == 'running' then
				table.remove(game.citizens, i)
				game.player.eaten = game.player.eaten + 1
			end

			if person.y > topScreenHeight or person.y < 0 then
				table.remove(game.citizens, i)
			end

			if person.y > topScreenHeight then
				game.jobs = game.jobs - 1
			end

			if person.y < 0 then game.totalThrown = game.totalThrown + 1 end


		end

		spawnTimer = spawnTimer + dt

		if spawnTimer > 0.5 then 
			game.generate(1)
			spawnTimer = spawnTimer - 0.5
		end

		if game.jobs <= 0 then
			state.setState('gameover')
		end

	end

end

function game.drawtop()

	if not state.isCurrentState('game') then

		love.graphics.setColor(255, 255, 255)

		love.graphics.rectangle('fill', 0, 0, topScreenWidth, topScreenHeight)

		love.graphics.draw(game.logo, 0, 0)

	end

	if state.isCurrentState('game') then

		love.graphics.draw(game.bgImage, 0, 0) -- Background

		love.graphics.rectangle('fill', 0, 100 + game.player.height, topScreenWidth, 1)

		for i, person in ipairs(game.citizens) do
			person:draw()
		end

		game.player:draw()

	end

end

function game.drawbottom()

	love.graphics.setColor(255, 255, 255)

	love.graphics.setBackgroundColor(34, 64, 154)

	love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)

	if state.isCurrentState('menu') then

		menu.drawbot()

	end

	if state.isCurrentState('game') then

		love.graphics.setBackgroundColor(50, 50, 200)

		love.graphics.setColor(0, 200, 0)

		local text = 'Press A to launch people over wall'
		local x = (botScreenWidth / 2) - (defaultFont:getWidth(text) / 2)
		local y = (botScreenHeight / 3) - (defaultFont:getHeight() / 2)

		if game.player.y < 100 and game.player.eaten > 0 then love.graphics.print(text, x, y) end

		text = 'You need to be in The Trump Zone to launch'
		x = (botScreenWidth / 2) - (defaultFont:getWidth(text) / 2)

		love.graphics.setColor(255, 0, 0)

		if game.player.y > 100 and game.player.eaten > 0 then love.graphics.print(text, x, y) end

		love.graphics.setColor(255, 255, 255)

		text = 'Jobs Remaining: ' .. game.jobs
		x = (botScreenWidth / 2) - (defaultFont:getWidth(text) / 2)
		y = (botScreenHeight / 2) - (defaultFont:getHeight() / 2)

		love.graphics.print(text, x, y)

		text = 'Currently Eaten: ' .. game.player.eaten
		width = (30 * game.maxeaten)
		x = (botScreenWidth / 2) - (width / 2)
		y = (botScreenHeight / 2) - (defaultFont:getHeight() / 2) + 35

		love.graphics.rectangle('line', x, y, width, 25)

		if game.player.eaten > game.maxeaten / 4 then
			love.graphics.setColor(237, 206, 66)
		end

		if game.player.eaten > game.maxeaten / 2 then
			love.graphics.setColor(255, 145, 0)
		end

		if game.player.eaten == game.maxeaten then
			love.graphics.setColor(255, 0, 0)
		end

		love.graphics.rectangle('fill', x, y, (30 * game.player.eaten), 25)

		love.graphics.setColor(255, 255, 255)

		if game.player.eaten == game.maxeaten then
			love.graphics.print('FULL', (x + width / 2) - (defaultFont:getWidth('FULL') / 2), y + (defaultFont:getHeight() / 2))
		end

	end

	if state.isCurrentState('about') then

		about.draw()

	end

	if state.isCurrentState('gameover') then

		gameover.draw()

	end

end

function game.mousepressed(button, x, y)

	if state.isCurrentState('game') then

	end

end

function game.keypressed(key, isrepeat)

	if state.isCurrentState('menu') then

		menu.keypressed(key, isrepeat)

	end

	if key == 'start' or key == 'escape' then

		if state.isCurrentState('gameover') or state.isCurrentState('game') then
			game.reset()
		end

		state.setState('menu')

	end

	if state.isCurrentState('game') then

		game.player:keypressed(key, isrepeat)

	end

end

function game.generate(num)

	for i=1, num do
		table.insert(game.citizens, citizen:new(nil, nil, 8, 8))
	end

end

function game.reset()

	game.citizens = {}

	game.player = require 'game.entities.player':new(0, 0, 50, 50)

	spawnTimer = 0

	game.jobs = 5

	game.maxeaten = 5

	game.totalThrown = 0

	print('Game Reset!')


end

return game