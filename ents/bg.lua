bg = Entity("bg", e)

function bg:initialize()
	self.x = 800 / 2
	self.y = 600 / 2
	self.w = 10000
	self.h = 10000
	self.pers = true

	mad:setType(self, "ent")
end

function bg:update(dt)
	mad:setOrientation(self, "CENTER")
end

function bg:draw()
	col(255, 255, 255, 255)
	rect(self.ox, self.oy, self.w, self.h)
end