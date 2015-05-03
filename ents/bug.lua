bug = Entity("bug", e)

function bug:initialize(x, y)
	--init values
	self.super.initialize(self, x, y)
	self.w = 32; self.h = 32

	--sprites
	self.spr = mad:new_grid(self, "bug", self.w, self.h)
	self.buggin = mad:anim(self.grid('1-2', 1), 0.1)
	self.orientation = "CENTER"

	--personal vars
	self.spd = 4

	--add it to the array
	mad:setType(self, "ent")
end

function bug:update(dt)
	--cam:lookAt(self.x, self.y)
	--movement
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

	--animation updating
	self.buggin:update(dt)

	--zord/set orientation
	self.super:update(self)
end

function bug:draw()
	col(255, 255, 255, 255)
	self.buggin:draw(self.spr, self.ox, self.oy)
end