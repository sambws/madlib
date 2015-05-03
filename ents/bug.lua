bug = Entity("bug", e)

function bug:initialize(x, y)
	--init values
	self.super.initialize(self, x, y)
	self.w = 32; self.h = 32

	--sprites
	self.spr = mad:new_grid(self, "bug", self.w, self.h)
	self.orientation = "CENTER"
	--anims
	self.buggin = mad:anim(self.grid('1-2', 1), 0.1)

	--personal vars
	self.spd = 4

	--add it to the array
	mad:setType(self, "ent")
end

function bug:update(dt)
	--cam:lookAt(self.x, self.y)
	self.x, self.y = cam:worldCoords(love.mouse.getPosition())

	--clamp x/y
	self.x = clamp(0, self.x, 800)
	self.y = clamp(0, self.y, 600)

	--animation updating
	self.buggin:update(dt)

	--zord/set orientation
	self.super:update(self, false)
end

function bug:draw()
	col(255, 255, 255, 255)
	self.buggin:draw(self.spr, self.ox, self.oy)
	--mad:testOrigin(self)
end