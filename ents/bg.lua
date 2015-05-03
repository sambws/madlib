bg = Entity("bg", e)

function bg:initialize()
	self.name = "bg"
	self.x = 0
	self.y = 0
	self.w = 800
	self.h = 600
	self.pers = true

	mad:addEnt(self)
end

function bg:update(dt)
end

function bg:draw()
	col(255, 255, 255, 255)
	rect(self.x, self.y, self.w, self.h)
end