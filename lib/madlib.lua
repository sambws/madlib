--MADLIB.LUA
--[[
this is a simple framework/library thing that adds things like entities, rooms, and shorthands to love2d.
it focuses on minimalism and modification possibility to make your life easier.
         __
        /  \
       / ..|\
      (_\  |_)
      /  \@'
     /     \
 _  /  `   |
\\/  \  | _\
 \   /_ || \\_
  \____)|_) \_)

--TODO--
+sounds sounds sounds
+research a good collision engine (check if bump 3.0 has support for slopes and diagonal walls and stuff)

--GLARING PROBLEMS--

--IDEAS--
+clean this mess

--SOLVED PROBLEMS--
+weird class var inheritence was caused by using a shorthand for self and not actually writing self
+added middleclass support
+the persistence problems were caused by the zord system, which reorganized the table. this would bring up problems when changing rooms.
i got around this by making it so that it wouldn't z-order in the mad:draw when the changed_room variable is true

--CURRENT FEATURES--
z-ordering
entity and class system
sprite orientation system
room system
shorthands for certain love2d functions (graphic primitives, key inputs)
anim8 support/shorthands
hump.camera support
]]

--require
require "lib.require"
--classes
class = require "lib.middleclass"
--anim8
anim8 = require "lib.anim8"
--cam
camera = require("lib.camera")

mad = {} --home
ents = {} --used to store ents
gui = {} --used to store gui elements
room = "" --used to run room code/make levels a thing

debug = true --show console y/n

--filepaths
ent_path = "ents"
img_path = "res/imgs"
snd_path = "res/snds"

local changed_room = true --this variable checks if the room is switching. if it is, it runs the init function for the room. it is usually set to false, and only true when you want to run the init function (on entrance to the room)

--empty ent class (base)
e = class('Entity')
function e:initialize(x, y)
	self.x = x
	self.y = y
end

function e:update(s)
	if s.orientation ~= nil or s.orientation ~= "" then
		mad:setOrientation(s, s.orientation)
	else
		mad:setOrientation(s, "TOPLEFT")
	end
	mad:zord(s)
end

--core functions
function mad:load()
	--setup the camera
	cam = camera(0, 0)
	local camx, camy = cam:cameraCoords(0, 0)
	cam:lookAt(camx, camy)
end

function mad:update(dt)
	for k,v in pairs(ents) do
		if v.update then v:update(dt) end
	end
	for k,v in pairs(gui) do
		if v.update then v:update(dt) end
	end
end

local function drawSort(a,b) return a.z > b.z end
function mad:draw()
	cam:attach()
	--render and zord ents inside the camera
	if not changed_room then table.sort(ents, drawSort) end
	for k,v in pairs(ents) do
		if v.draw then v:draw() end
	end
	cam:detach()
	--render gui outside of the camera
	for k,v in pairs(gui) do
		if v.draw then v:draw() end
	end
end

function mad:pressed(key)
	if key == "`" then
		if not debug then debug = true
		else debug = false end
	end
end

--entities
function Entity(name, sub) --returns entity generated
	local t = class(name, sub)
	--DEFAULT ENT VALUES ARE SET HERE!
	t.x = 0
	t.y = 0
	t.w = 32
	t.h = 32
	t.z = 0
	t.name = name
	t.pers = false
	t.__index = t
	return t
end

function mad:addEnt(ent, xx, yy)
	local e = ent:new(xx, yy)
	return e
end

function mad:setType(s, t)
	if t == "ent" then
		table.insert(ents, s)
	elseif t == "gui" then
		table.insert(gui, s)
	end
end

function mad:removeEnt(t)
	for k,v in pairs(ents) do
		if v == t then
			table.remove(ents, k)
			print("removed " .. v.name)
		end
	end
end

--rooms
function mad:changeRoom(rm)
	changed_room = true
	room = rm
end

function mad:runRoom(name, f)
	--[[this function is designed to check if the room is ready to run
	and if it is, run it's init function which is defined as one of it's
	parameters.]]
	if room == name then --if the current room is the checked room..
		if changed_room then
			for k,v in pairs(ents) do --remove persistent ents
				if v.pers == false or v.pers == nil then
					removeEnt(v)
				end
			end
			f() --run the function
			changed_room = false
		end
	end
end

--zords zords zords
function mad:zord(e, mod)
	--different mods affect when the object will go in front/behind another
	--mod = 2: will change on center
	--mod = 1: will change on bottom
	mod = mod or 1
	e.z = -e.y - (e.h / mod)
end

--primitive shorthands
function circ(x, y, radius, segments)
	love.graphics.circle("fill", x, y, radius, segments)
end

function line(x1, y1, x2, y2)
	love.graphics.line(x1, y1, x2, y2)
end

function rect(x, y, w, h)
	love.graphics.rectangle("fill", x, y, w, h)
end

function col(r, g, b, a)
	love.graphics.setColor(r, g, b, a)
end

--text 
function new_font(fname, size) --returns font; should be run in love.loaded
	local font = love.graphics.newFont(fname, size)
	return font
end

function set_font(font)
	love.graphics.setFont(font)
end

function txt(txt, x, y)
	love.graphics.print(txt, x, y)
end

--images and animation
--generates img
function mad:new_img(t) --returns image
	local t = love.graphics.newImage(img_path .. "/" .. t .. ".png")
	return t
end

--generates grid + image
function mad:new_grid(s, t, w, h)
	local t = love.graphics.newImage(img_path .. "/" .. t .. ".png")
	s.grid = mad:grid(t, w, h)
	return t
end

function mad:setOrientation(s, o)
	if o == "CENTER" then
		s.ox = s.x - (s.w / 2)
		s.oy = s.y - (s.h / 2)
	elseif o == "TOPLEFT" then
		s.ox = s.x
		s.oy = s.y
	elseif o == "TOP" then
		s.ox = s.x - (s.w / 2)
		s.oy = s.y
	elseif o == "TOPRIGHT" then
		s.ox = s.x - s.w
		s.oy = s.y
	elseif o == "BOTLEFT" then
		s.ox = s.x
		s.oy = s.y - s.h
	elseif o == "BOT" then
		s.ox = s.x - (s.w / 2)
		s.oy = s.y - s.h
	elseif o == "BOTRIGHT" then
		s.ox = s.x - s.w
		s.oy = s.y - s.h
	end
end

function mad:draw_anim(s, anim)
	anim:draw(s.spr, s.x - (s.w / 2), s.y - (s.h / 2))
end

function img(i, x, y)
	love.graphics.draw(i, x, y)
end

--input
function mad:key(k)
	if love.keyboard.isDown(k) then
		return true
	else
		return false
	end
end

--animation and sprites
--returns grid
function mad:grid(img, fw, fh)
	local g = anim8.newGrid(fw, fh, img:getWidth(), img:getHeight())
	return g
end

--returns anim
function mad:anim(frames, spd)
	local a = anim8.newAnimation(frames, spd)
	return a
end

--will get an image and then make an animation grid from it
function mad:get_sprite(img, fw, fh, s)
	s.spr = new_img(img)
	local g = grid(s.spr, fw, fh)
	return g
end

--ez math
function mad:clamp(low, n, high) return math.min(math.max(low, n), high) end

function rand(min, max) --returns random number
	local q = love.math.random(min, max)
	return q
end