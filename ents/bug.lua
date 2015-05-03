bug = Entity("bug", e)

function bug:initialize(x, y)
	self.x = x;	self.y = y
	self.w = 32; self.h = 32

	self.spr = mad:new_grid(self, "bug", self.w, self.h)
	self.buggin = mad:anim(self.grid('1-2', 1), 0.1)

	self.spd = 4

	mad:addEnt(self)
end

function bug:update(dt)
	mad:setOrientation(self, "CENTER")

	if mad:key("left") then
		self.x = self.x - self.spd
	elseif mad:key("right") then
		self.x = self.x + self.spd
	end
	if mad:key("up") then
		self.y = self.y - self.spd
	elseif mad:key("down") then
		self.y = self.y + self.spd
	end

	--clamp x/y
	self.x = mad:clamp(0, self.x, 800)
	self.y = mad:clamp(0, self.y, 600)

	self.buggin:update(dt)
	mad:zord(self)
end

function bug:draw()
	col(255, 255, 255, 255)
	self.buggin:draw(self.spr, self.ox, self.oy)
end