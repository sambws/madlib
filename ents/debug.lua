debug = Entity("debug", e)

function debug:initialize(x, y)
	self.name = "debug"
	self.x = x; self.y = y
	self.w = 0; self.h = 0
	self.pers = true

	mad:addEnt(self)
end

function debug:update(dt)
end

function debug:draw()
	col(0, 0, 0, 255)
	txt("current fps: " .. love.timer.getFPS(), 0, 0)
	txt("current room: " .. room, 0, 16)
end