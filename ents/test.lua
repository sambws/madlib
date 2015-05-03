test = Entity("test", e)

function test:initialize(x, y)
	--init values
	self.super.initialize(self, x, y)
	self.w = 64; self.h = 64

	self.orientation = "CENTER"

	--add it to the array
	mad:setType(self, "ent")
end

function test:update(dt)
	self.x = self.x + 1
	self.y = self.y + 1
	self.super:update(self)
end

function test:draw()
	col(0, 0, 0, 255)
	rect(self.ox, self.oy, self.w, self.h)
	--mad:testOrigin(self)
end