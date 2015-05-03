require "lib.madlib"
require.tree(ent_path)

function love.load()
	mad:load();
	mad:changeRoom("test")

	--add bg
	local _bg = bg:new(0, 0)
end

function love.update(dt)
	mad:update(dt)

	mad:runRoom("test", function()
		mad:addEnt(bug, rand(0, 800), rand(0, 600))
		mad:addEnt(test, 60, 50)
	end)
end

function love.keypressed(key)
	mad:pressed(key)
end

function love.draw()
	mad:draw()
end