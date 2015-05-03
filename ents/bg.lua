bg = Entity("bg", e)

function bg:initialize()
	self.x = 800 / 2
	self.y = 600 / 2
	self.w = 20000
	self.h = 20000
	self.pers = true

	mad:addEnt(self)
end

function bg:update(dt)
	mad:setOrientation(self, "CENTER")
end

function bg:draw()
	col(255, 255, 255, 255)
	rect(self.ox, self.oy, self.w, self.h)
end