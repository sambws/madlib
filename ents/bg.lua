bg = Entity("bg", e)

function bg:initialize()
	self.x = 0
	self.y = 0
	self.w = 10000
	self.h = 10000
	self.pers = true

	self.orientation = "TOPLEFT"

	mad:setType(self, "ent")
end

function bg:update(dt)
end

function bg:draw()
	col(255, 255, 255, 255)
	rect(self.ox, self.oy, self.w, self.h)
end