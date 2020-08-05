---
-- @module bt_mobs

--
-- Based on a modified version of the mobkit mod that uses behavior trees instead of queues
--
-- original mobkit mod repo: https://github.com/TheTermos/mobkit
--
-- modified by Jake Hooper (AKA jSnake)
--

local math_pi = math.pi
local math_min = math.min
local math_max = math.max
local math_abs = math.abs
local math_floor = math.floor
local math_ceil = math.ceil
local math_sqrt = math.sqrt
local math_tan = math.tan
local math_atan2 = math.atan2
local math_random = math.random


local sign = function(x)
	return (x<0) and -1 or 1
end

local abr = tonumber(minetest.get_mapgen_setting('active_block_range')) or 3
local node_lava = nil

local neighbors ={
	{x=1,z=0},
	{x=1,z=1},
	{x=0,z=1},
	{x=-1,z=1},
	{x=-1,z=0},
	{x=-1,z=-1},
	{x=0,z=-1},
	{x=1,z=-1}
	}

--- Mob gravitational acceleration
bt_mobs.gravity = -9.8

--- Mob default friction
bt_mobs.friction = 0.4

--- The terminal velocity for falling mobs
bt_mobs.terminal_velocity = math_sqrt(2*-bt_mobs.gravity*20) -- 20 meter fall = dead

--- velocity at which a mob will not be damaged
bt_mobs.safe_velocity = math_sqrt(2*-bt_mobs.gravity*5) -- 5 m safe fall

--- Calculate dot product of two vectors
-- @tparam vector v1 First vector to calculate
-- @tparam vector v2 Second vector to calculate
-- @treturn vector Result of the dot product calculation
function bt_mobs.dot(v1,v2)
	return v1.x*v2.x+v1.y*v2.y+v1.z*v2.z
end

--- limits a number to within a positive or negative maximum
-- @number val The value to be limited
-- @number max The maximum magnitude (positive or negative) the value should be limited to
-- @treturn number The value within the imposed limit
function bt_mobs.minmax(val, max)
	return math_min(math_abs(val), max) * sign(val)
end


function bt_mobs.dir2neighbor(dir)
	dir.y=0
	dir=vector.round(vector.normalize(dir))
	for k,v in ipairs(neighbors) do
		if v.x == dir.x and v.z == dir.z then return k end
	end
	return 1
end

function bt_mobs.neighbor_shift(neighbor,shift)	-- int shift: minus is left, plus is right
	return (8+neighbor+shift-1)%8+1
end

function bt_mobs.pos_shift(pos,vec) -- vec components can be omitted e.g. vec={y=1}
	vec.x=vec.x or 0
	vec.y=vec.y or 0
	vec.z=vec.z or 0
	return {x=pos.x+vec.x,
			y=pos.y+vec.y,
			z=pos.z+vec.z}
end

function bt_mobs.pos_translate2d(pos,yaw,dist) -- translate pos dist distance in yaw direction
	return vector.add(pos,vector.multiply(minetest.yaw_to_dir(yaw),dist))
end

function bt_mobs.is_pos_in_box(pos,bpos,box)
	return pos.x > bpos.x+box[1] and pos.x < bpos.x+box[4] and
			pos.y > bpos.y+box[2] and pos.y < bpos.y+box[5] and
			pos.z > bpos.z+box[3] and pos.z < bpos.z+box[6]
end

-- call this instead if you want feet position.
--[[
function bt_mobs.get_stand_pos(thing)	-- thing can be luaentity or objectref.
	if type(thing) == 'table' then
		return bt_mobs.pos_shift(thing.object:get_pos(),{y=thing.collisionbox[2]+0.01})
	elseif type(thing) == 'userdata' then
		local colbox = thing:get_properties().collisionbox
		return bt_mobs.pos_shift(thing:get_pos(),{y=colbox[2]+0.01})
	end
end	--]]

function bt_mobs.get_stand_pos(thing)	-- thing can be luaentity or objectref.
	local pos
	local colbox
	if type(thing) == 'table' then
		pos = thing.object:get_pos()
		colbox = thing.object:get_properties().collisionbox
	elseif type(thing) == 'userdata' then
		pos = thing:get_pos()
		colbox = thing:get_properties().collisionbox
	else
		return false
	end
	return bt_mobs.pos_shift(pos,{y=colbox[2]+0.01}), pos
end

function bt_mobs.set_acceleration(thing,vec,limit)
	limit = limit or 100
	if type(thing) == 'table' then thing=thing.object end
	vec.x=bt_mobs.minmax(vec.x,limit)
	vec.y=bt_mobs.minmax(vec.y,limit)
	vec.z=bt_mobs.minmax(vec.z,limit)
	
	thing:set_acceleration(vec)
end

function bt_mobs.nodeatpos(pos)
	local node = minetest.get_node_or_nil(pos)
	if node then return minetest.registered_nodes[node.name] end
end

function bt_mobs.get_nodename_off(pos,vec)
	return minetest.get_node(bt_mobs.pos_shift(pos,vec)).name
end

function bt_mobs.get_node_pos(pos)
	return  {
		x=math_floor(pos.x+0.5),
		y=math_floor(pos.y+0.5),
		z=math_floor(pos.z+0.5),
	}
end

function bt_mobs.get_nodes_in_area(pos1,pos2,full)
	local npos1=bt_mobs.get_node_pos(pos1)
	local npos2=bt_mobs.get_node_pos(pos2)
	local result = {}
	local cnt = 0	-- safety
	
	local sx = (pos2.x<pos1.x) and -1 or 1
	local sz = (pos2.z<pos1.z) and -1 or 1
	local sy = (pos2.y<pos1.y) and -1 or 1
	
	local x=npos1.x-sx
	local z --=npos1.z-sz
	local y --=npos1.y-sy
	
	repeat
		x=x+sx
		z=npos1.z-sz
		repeat
			z=z+sz
			y=npos1.y-sy
			repeat
				y=y+sy
				
				local pos = {x=x,y=y,z=z}
				local node = bt_mobs.nodeatpos(pos)
				if node	then
					if full==true then
						result[pos] = node
					else
						result[node] = true
					end
				end
			
				cnt=cnt+1
				if cnt > 125 then
					minetest.chat_send_all('get_nodes_in_area: area too big ')
					return result
				end
			
			until y==npos2.y
		until z==npos2.z
	until x==npos2.x
	
	return result
end

function bt_mobs.get_hitbox_bottom(self)
	local y = self.collisionbox[2]
	local pos = self.object:get_pos()
	return {
			{x=pos.x+self.collisionbox[1],y=pos.y+y,z=pos.z+self.collisionbox[3]},
			{x=pos.x+self.collisionbox[1],y=pos.y+y,z=pos.z+self.collisionbox[6]},
			{x=pos.x+self.collisionbox[4],y=pos.y+y,z=pos.z+self.collisionbox[3]},
			{x=pos.x+self.collisionbox[4],y=pos.y+y,z=pos.z+self.collisionbox[6]},
		}
end
		
function bt_mobs.get_node_height(pos)
	local npos = bt_mobs.get_node_pos(pos)
	local node = bt_mobs.nodeatpos(npos)
	if node == nil then return nil end
	
	if node.walkable then
		if node.drawtype == 'nodebox' then
			if node.node_box and node.node_box.type == 'fixed' then
				if type(node.node_box.fixed[1]) == 'number' then
					return npos.y + node.node_box.fixed[5] ,0, false
				elseif type(node.node_box.fixed[1]) == 'table' then
					return npos.y + node.node_box.fixed[1][5] ,0, false
				else
					return npos.y + 0.5,1, false			-- todo handle table of boxes
				end
			elseif node.node_box and node.node_box.type == 'leveled' then
				return minetest.get_node_level(pos)/64-0.5+bt_mobs.get_node_pos(pos).y, 0, false
			else
				return npos.y + 0.5,1, false	-- the unforeseen
			end
		else
			return npos.y+0.5,1, false	-- full node
		end
	else
		local liquidflag = false
		if node.drawtype == 'liquid' then liquidflag = true end
		return npos.y-0.5,-1,liquidflag
	end
end

-- get_terrain_height
-- steps(optional) number of recursion steps; default=3
-- dir(optional) is 1=up, -1=down, 0=both; default=0
-- liquidflag(forbidden) never provide this parameter.
function bt_mobs.get_terrain_height(pos,steps,dir,liquidflag) --dir is 1=up, -1=down, 0=both
	steps = steps or 3
	dir = dir or 0

	local h,f,l = bt_mobs.get_node_height(pos)
	if h == nil then return nil end
	if l then liquidflag = true end
	
	if f==0 then
		return h, liquidflag
	end
	
	if dir==0 or dir==f then
		steps = steps - 1
		if steps <=0 then return nil end
		return bt_mobs.get_terrain_height(bt_mobs.pos_shift(pos,{y=f}),steps,f,liquidflag)
	else
		return h, liquidflag
	end
end

function bt_mobs.get_spawn_pos_abr(dtime,intrvl,radius,chance,reduction)
	local plyrs = minetest.get_connected_players()
	intrvl=1/intrvl

	if math_random()<dtime*(intrvl*#plyrs) then
		local plyr = plyrs[math_random(#plyrs)]		-- choose random player
		local vel = plyr:get_player_velocity()
		local spd = vector.length(vel)
		chance = (1-chance) * 1/(spd*0.75+1)
		
		local yaw
		if spd > 1 then
			-- spawn in the front arc
			yaw = minetest.dir_to_yaw(vel) + math_random()*0.35 - 0.75
		else
			-- random yaw
			yaw = math_random()*math_pi*2 - math_pi
		end
		local pos = plyr:get_pos()
		local dir = vector.multiply(minetest.yaw_to_dir(yaw),radius)
		local pos2 = vector.add(pos,dir)
		pos2.y=pos2.y-5
		local height, liquidflag = bt_mobs.get_terrain_height(pos2,32)
		if height then
			local objs = minetest.get_objects_inside_radius(pos,radius*1.1)
			for _,obj in ipairs(objs) do				-- count mobs in abrange
				if not obj:is_player() then
					local lua = obj:get_luaentity()
					if lua and lua.name ~= '__builtin:item' then
						chance=chance + (1-chance)*reduction	-- chance reduced for every mob in range
					end
				end
			end
			if chance < math_random() then
				pos2.y = height
				objs = minetest.get_objects_inside_radius(pos2,radius*0.95)
				for _,obj in ipairs(objs) do				-- do not spawn if another player around
					if obj:is_player() then return end
				end
				return pos2, liquidflag
			end
		end
	end
end

function bt_mobs.turn2yaw(self,tyaw,rate)
	tyaw = tyaw or 0 --temp
	rate = rate or 6
		local yaw = self.object:get_yaw()
		yaw = yaw+math_pi
		tyaw=(tyaw+math_pi)%(math_pi*2)
		
		local step=math_min(self.dtime*rate,math_abs(tyaw-yaw)%(math_pi*2))
		
		local dir = math_abs(tyaw-yaw)>math_pi and -1 or 1
		dir = tyaw>yaw and dir*1 or dir * -1
		
		local nyaw = (yaw+step*dir)%(math_pi*2)
		self.object:set_yaw(nyaw-math_pi)
		
		if nyaw==tyaw then return true, nyaw-math_pi
		else return false, nyaw-math_pi end
end

function bt_mobs.dir_to_rot(v,rot)
	rot = rot or {x=0,y=0,z=0}
	return {x = (v.x==0 and v.y==0 and v.z==0) and rot.x or math_atan2(v.y,vector.length({x=v.x,y=0,z=v.z})),
			y = (v.x==0 and v.z==0) and rot.y or minetest.dir_to_yaw(v),
			z=rot.z}
end

function bt_mobs.rot_to_dir(rot) -- keep rot within <-pi/2,pi/2>
	local dir = minetest.yaw_to_dir(rot.y)
	dir.y = dir.y+math_tan(rot.x)*vector.length(dir)
	return vector.normalize(dir)
end

function bt_mobs.isnear2d(p1,p2,thresh)
	if math_abs(p2.x-p1.x) < thresh and math_abs(p2.z-p1.z) < thresh then
		return true
	else
		return false
	end
end

-- object has reached the destination if dest is in the rear half plane.
function bt_mobs.is_there_yet2d(pos,dir,dest) -- obj positon; facing vector; destination position

	local c = -dir.x*pos.x-dir.z*pos.z						-- the constant
	
	if dir.z > 0 then
		return dest.z <= (-dir.x*dest.x - c)/dir.z			-- line equation
	elseif dir.z < 0 then
		return dest.z >= (-dir.x*dest.x - c)/dir.z
	elseif dir.x > 0 then
		return dest.x <= (-dir.z*dest.z - c)/dir.x
	elseif dir.x < 0 then
		return dest.x >= (-dir.z*dest.z - c)/dir.x
	else
		return false
	end
	
end

function bt_mobs.isnear3d(p1,p2,thresh)
	if math_abs(p2.x-p1.x) < thresh and math_abs(p2.z-p1.z) < thresh and math_abs(p2.y-p1.y) < thresh then
		return true
	else
		return false
	end
end

function bt_mobs.get_box_height(thing)
	if type(thing) == 'table' then thing = thing.object end
	local colbox = thing:get_properties().collisionbox
	local height
	if colbox then
		height = colbox[5]-colbox[2]
	else
		height = 0.1
	end
	
	return height > 0 and height or 0.1
end

function bt_mobs.is_alive(thing)		-- thing can be luaentity or objectref.
	--	if not thing then return false end
	if not bt_mobs.exists(thing) then return false end
	if type(thing) == 'table' then return thing.hp > 0 end
	if thing:is_player() then
		return thing:get_hp() > 0
	else
		local lua = thing:get_luaentity()
		local hp = lua and lua.hp or nil
		return hp and hp > 0
	end
end

function bt_mobs.exists(thing)
	if not thing then return false end
	if type(thing) == 'table' then thing=thing.object end
	if type(thing) == 'userdata' then
		if thing:is_player() then
			if thing:get_look_horizontal() then return true end
		else
			if thing:get_yaw() then return true end
		end
	end
end

function bt_mobs.hurt(luaent,dmg)
	if not luaent then return false end
	if type(luaent) == 'table' then
		luaent.hp = math_max((luaent.hp or 0) - dmg,0)
	end
end

function bt_mobs.lava_hurt(self,dmg)
	node_lava = node_lava or minetest.registered_nodes[minetest.registered_aliases.mapgen_lava_source]
	if node_lava then
		local pos=self.object:get_pos()
		local box = self.object:get_properties().collisionbox
		local pos1={ x=pos.x+box[1], y=pos.y+box[2], z=pos.z+box[3] }
		local pos2={ x=pos.x+box[4], y=pos.y+box[5], z=pos.z+box[6] }
		local nodes=bt_mobs.get_nodes_in_area(pos1, pos2)

		if nodes[node_lava] then bt_mobs.hurt(self,dmg) end
	end
end

function bt_mobs.heal(luaent,dmg)
	if not luaent then return false end
	if type(luaent) == 'table' then
		luaent.hp = math_min(luaent.max_hp,(luaent.hp or 0) + dmg)
	end
end

function bt_mobs.animate(self,anim)
	if self.animation and self.animation[anim] then
		if self._anim == anim then return end
		self._anim=anim
		
		local aparms
		if #self.animation[anim] > 0 then
			aparms = self.animation[anim][math_random(#self.animation[anim])]
		else
			aparms = self.animation[anim]
		end
		
		self.object:set_animation(aparms.range,aparms.speed,0,aparms.loop)
	else
		self._anim = nil
	end
end

function bt_mobs.make_sound(self, sound)
	local spec = self.sounds and self.sounds[sound]
	local param_table = {object=self.object}
	
	if type(spec) == 'table' then
		--pick random sound if it's a spec for random sounds
		if #spec > 0 then spec = spec[math_random(#spec)] end
		
		--returns value or a random value within the range [value[1], value[2])
		local function in_range(value)
			return type(value) == 'table' and value[1]+math_random()*(value[2]-value[1]) or value
		end
		
		--pick random values within a range if they're a table
		param_table.gain = in_range(spec.gain)
		param_table.fade = in_range(spec.fade)
		param_table.pitch = in_range(spec.pitch)
		return minetest.sound_play(spec.name, param_table)
	end
	return minetest.sound_play(spec, param_table)
end

function bt_mobs.is_neighbor_node_reachable(self,neighbor)	-- todo: take either number or pos
	local offset = neighbors[neighbor]
	local pos=bt_mobs.get_stand_pos(self)
	local tpos = bt_mobs.get_node_pos(bt_mobs.pos_shift(pos,offset))
	local recursteps = math_ceil(self.jump_height)+1
	local height, liquidflag = bt_mobs.get_terrain_height(tpos,recursteps)

	if height and math_abs(height-pos.y) <= self.jump_height then
		tpos.y = height
		height = height - pos.y
		
		-- don't cut corners
		if neighbor % 2 == 0 then				-- diagonal neighbors are even
			local n2 = neighbor-1				-- left neighbor never < 0
			offset = neighbors[n2]
			local t2 = bt_mobs.get_node_pos(bt_mobs.pos_shift(pos,offset))
			local h2 = bt_mobs.get_terrain_height(t2,recursteps)
			if h2 and h2 - pos.y > 0.02 then return end
			n2 = (neighbor+1)%8 		-- right neighbor
			offset = neighbors[n2]
			t2 = bt_mobs.get_node_pos(bt_mobs.pos_shift(pos,offset))
			h2 = bt_mobs.get_terrain_height(t2,recursteps)
			if h2 and h2 - pos.y > 0.02 then return end
		end
	
		-- check headroom
		if tpos.y+self.height-pos.y > 1 then			-- if head in next node above, else no point checking headroom
			local snpos = bt_mobs.get_node_pos(pos)
			local pos1 = {x=pos.x,y=snpos.y+1,z=pos.z}						-- current pos plus node up
			local pos2 = {x=tpos.x,y=tpos.y+self.height,z=tpos.z}			-- target head pos

			local nodes = bt_mobs.get_nodes_in_area(pos1,pos2,true)
			
			for p,node in pairs(nodes) do
				if snpos.x==p.x and snpos.z==p.z then
					if node.name=='ignore' or node.walkable then return end
				else
					if node.name=='ignore' or
							(node.walkable and bt_mobs.get_node_height(p)>tpos.y+0.001) then
						return
					end
				end
			end
		end
		
		return height, tpos, liquidflag
	else
		return
	end
end

function bt_mobs.get_next_waypoint(self,tpos)
	local pos = bt_mobs.get_stand_pos(self)
	local dir=vector.direction(pos,tpos)
	local neighbor = bt_mobs.dir2neighbor(dir)
	local function update_pos_history(this_self,this_pos)
		table.insert(this_self.pos_history,1,this_pos)
		if #this_self.pos_history > 2 then table.remove(this_self.pos_history,#this_self.pos_history) end
	end
	local nogopos = self.pos_history[2]
	
	local height, pos2, liquidflag = bt_mobs.is_neighbor_node_reachable(self,neighbor)
--minetest.chat_send_all('pos2 ' .. minetest.serialize(pos2))
--minetest.chat_send_all('nogopos ' .. minetest.serialize(nogopos))
	if height and not liquidflag
			and not (nogopos and bt_mobs.isnear2d(pos2,nogopos,0.1)) then

		local heightl = bt_mobs.is_neighbor_node_reachable(self,bt_mobs.neighbor_shift(neighbor,-1))
		if heightl and math_abs(heightl-height)<0.001 then
			local heightr = bt_mobs.is_neighbor_node_reachable(self,bt_mobs.neighbor_shift(neighbor,1))
			if heightr and math_abs(heightr-height)<0.001 then
				dir.y = 0
				local dirn = vector.normalize(dir)
				local npos = bt_mobs.get_node_pos(bt_mobs.pos_shift(pos,neighbors[neighbor]))
				local factor = math_abs(dirn.x) > math_abs(dirn.z) and math_abs(npos.x-pos.x) or math_abs(npos.z-pos.z)
				pos2=bt_mobs.pos_shift(pos,{x=dirn.x*factor,z=dirn.z*factor})
			end
		end
		update_pos_history(self,pos2)
		return height, pos2
	else

		for i=1,3 do
			-- scan left
			height, pos2, liquidflag = bt_mobs.is_neighbor_node_reachable(
				self,bt_mobs.neighbor_shift(neighbor,-i*self.path_dir)
			)
			if height and not liquidflag
			and not (nogopos and bt_mobs.isnear2d(pos2,nogopos,0.1)) then
				update_pos_history(self,pos2)
				return height,pos2
			end
			-- scan right
			height, pos2, liquidflag = bt_mobs.is_neighbor_node_reachable(
				self,bt_mobs.neighbor_shift(neighbor,i*self.path_dir)
			)
			if height and not liquidflag
					and not (nogopos and bt_mobs.isnear2d(pos2,nogopos,0.1)) then
				update_pos_history(self,pos2)
				return height,pos2
			end
		end
		--scan rear
		height, pos2, liquidflag = bt_mobs.is_neighbor_node_reachable(
			self,bt_mobs.neighbor_shift(neighbor,4)
		)
		if height and not liquidflag
				and not (nogopos and bt_mobs.isnear2d(pos2,nogopos,0.1)) then
			update_pos_history(self,pos2)
			return height,pos2
		end
	end
	-- stuck condition here
	table.remove(self.pos_history,2)
	self.path_dir = self.path_dir*-1	-- subtle change in pathfinding
end

function bt_mobs.get_next_waypoint_fast(self,tpos,nogopos)
	local pos = bt_mobs.get_stand_pos(self)
	local dir=vector.direction(pos,tpos)
	local neighbor = bt_mobs.dir2neighbor(dir)
	local height, pos2, liquidflag = bt_mobs.is_neighbor_node_reachable(self,neighbor)
	
	if height and not liquidflag then
		local fast = false
		local heightl = bt_mobs.is_neighbor_node_reachable(self,bt_mobs.neighbor_shift(neighbor,-1))
		if heightl and math_abs(heightl-height)<0.001 then
			local heightr = bt_mobs.is_neighbor_node_reachable(self,bt_mobs.neighbor_shift(neighbor,1))
			if heightr and math_abs(heightr-height)<0.001 then
				fast = true
				dir.y = 0
				local dirn = vector.normalize(dir)
				local npos = bt_mobs.get_node_pos(bt_mobs.pos_shift(pos,neighbors[neighbor]))
				local factor = math_abs(dirn.x) > math_abs(dirn.z) and math_abs(npos.x-pos.x) or math_abs(npos.z-pos.z)
				pos2=bt_mobs.pos_shift(pos,{x=dirn.x*factor,z=dirn.z*factor})
			end
		end
		return height, pos2, fast
	else

		for i=1,4 do
			-- scan left
			height, pos2, liquidflag = bt_mobs.is_neighbor_node_reachable(
				self,bt_mobs.neighbor_shift(neighbor,-i)
			)
			if height and not liquidflag then return height,pos2 end
			-- scan right
			height, pos2, liquidflag = bt_mobs.is_neighbor_node_reachable(
				self,bt_mobs.neighbor_shift(neighbor,i)
			)
			if height and not liquidflag then return height,pos2 end
		end
	end
end

function bt_mobs.go_forward_horizontal(self,speed)	-- sets velocity in yaw direction, y component unaffected
	local y = self.object:get_velocity().y
	local yaw = self.object:get_yaw()
	local vel = vector.multiply(minetest.yaw_to_dir(yaw),speed)
	vel.y = y
	self.object:set_velocity(vel)
end

function bt_mobs.drive_to_pos(self,tpos,speed,turn_rate,dist)
	local pos=self.object:get_pos()
	dist = dist or 0.2
	if bt_mobs.isnear2d(pos,tpos,dist) then return true end
	local tyaw = minetest.dir_to_yaw(vector.direction(pos,tpos))
	bt_mobs.turn2yaw(self,tyaw,turn_rate)
	bt_mobs.go_forward_horizontal(self,speed)
	return false
end

function bt_mobs.timer(self,s) -- returns true approx every s seconds
	local t1 = math_floor(self.time_total)
	local t2 = math_floor(self.time_total+self.dtime)
	if t2>t1 and t2%s==0 then return true end
end

-- -- Memory functions.
-- -- Stuff in memory is serialized, never try to remember objectrefs.
-- function bt_mobs.remember(self,key,val)
-- 	self.memory[key]=val
-- 	return val
-- end

-- function bt_mobs.forget(self,key)
-- 	self.memory[key] = nil
-- end

-- function bt_mobs.recall(self,key)
-- 	return self.memory[key]
-- end



function bt_mobs.get_nearby_player(self)	-- returns random player if nearby or nil
	for _,obj in ipairs(self.nearby_objects) do
		if obj:is_player() and bt_mobs.is_alive(obj) then return obj end
	end
	return
end

function bt_mobs.get_nearby_entity(self,name)	-- returns random nearby entity of name or nil
	for _,obj in ipairs(self.nearby_objects) do
		if bt_mobs.is_alive(obj) and not obj:is_player() and obj:get_luaentity().name == name then return obj end
	end
	return
end

function bt_mobs.get_closest_entity(self,name)	-- returns closest entity of name or nil
	local cobj = nil
	local dist = abr*64
	local pos = self.object:get_pos()
	for _,obj in ipairs(self.nearby_objects) do
		local luaent = obj:get_luaentity()
		if bt_mobs.is_alive(obj) and not obj:is_player() and luaent and luaent.name == name then
			local opos = obj:get_pos()
			local odist = math_abs(opos.x-pos.x) + math_abs(opos.z-pos.z)
			if odist < dist then
				dist=odist
				cobj=obj
			end
		end
	end
	return cobj
end

local function sensors()
	local timer = 2
	local pulse = 1
	return function(self)
		timer=timer-self.dtime
		if timer < 0 then
		
			pulse = pulse + 1				-- do full range every third scan
			local range = self.view_range
			if pulse > 2 then
				pulse = 1
			else
				range = self.view_range*0.5
			end
			
			local pos = self.object:get_pos()
--local tim = minetest.get_us_time()
			self.nearby_objects = minetest.get_objects_inside_radius(pos, range)
--minetest.chat_send_all(minetest.get_us_time()-tim)
			for i,obj in ipairs(self.nearby_objects) do
				if obj == self.object then
					table.remove(self.nearby_objects,i)
					break
				end
			end
			timer=2
		end
	end
end

local function get_static_save_data(self)
    local tmp={}
    for k,v in pairs(self.static_save_keys or {}) do
        if not self[k] then
            if type(v) == "function" then
                tmp[k] = v(self)
            else
                tmp[k] = v
            end
        else
            tmp[k] = self[k]
        end
    end
    tmp.hp = self.hp
    return tmp
end

function bt_mobs.on_staticdata(self)
	return minetest.serialize(get_static_save_data(self))
end

function bt_mobs.on_activate(self, staticdata, dtime)

	self.physics = self.physics or bt_mobs.default_physics
	self.nearby_objects = {}
	self.nearby_players = {}
	self.pos_history = {}
	self.path_dir = 1
	self.time_total = 0
	self.water_drag = self.water_drag or 1

	local sdata = minetest.deserialize(staticdata)
	if sdata then
        for k,v in pairs(sdata) do
			self[k]= v
        end
    end

	-- if not self.blackboard then
	-- 	self.blackboard = {}
	-- end

    --if self.timeout and self.timeout > 0 and dtime > self.timeout and next(self.blackboard) == nil then
    if self.timeout and self.timeout > 0 and dtime > self.timeout then
		self.object:remove()
	end

	self.hp_max = self.hp_max or 20
	self.hp = self.hp or self.hp_max

	if type(self.armor_groups) ~= 'table' then
		self.armor_groups={}
	end
	self.armor_groups.immortal = 1
	self.object:set_armor_groups(self.armor_groups)

	-- if self.textures then
	-- 	local props = {}
	-- 	props.textures = self.textures
	-- 	self.object:set_properties(props)
	-- end
	
	self.buoyancy = self.buoyancy or 0
	self.breath = self.breath or self.breath_max
	self.last_velocity = {x=0,y=0,z=0}
    self.sense = sensors()

    self.on_brain_step = self.on_brain_step or bt_mobs.default_on_brain_step
    
    if self.behavior_tree then
        if type(self.behavior_tree) == "function" then

            self.behavior_tree = self:behavior_tree()
            assert(self.behavior_tree.is_a and self.behavior_tree.is_a(behaviors.tree),
                "Invalid behavior_tree property for entity "..self.name)
            if not self.behavior_tree.object then
                self.behavior_tree:set_object(self)
            end

        elseif type(self.behavior_tree) == "string" then
            self.behavior_tree = behaviors.load_and_build_owl_tree(self.behavior_tree)
            self.behavior_tree:set_object(self)
        else
            assert(self.behavior_tree.is_a and self.behavior_tree.is_a(behaviors.tree),
                "Invalid behavior_tree property for entity "..self.name)
            if not self.behavior_tree.object then
                self.behavior_tree:set_object(self)
            end
        end
    end

    -- get default values for the static data keys when activating
    for k,v in pairs(get_static_save_data(self)) do
        self[k]= v
    end
end

function bt_mobs.on_step(self, dtime)
	self.dtime = math_min(dtime, 0.2)
	self.height = bt_mobs.get_box_height(self)

	local vel = self.object:get_velocity()

	if self.last_velocity.y == 0 and vel.y == 0 then
		self.is_on_ground = true
	else
		self.is_on_ground = false
	end

    self:physics()
    
    if self.on_brain_step or self.behavior_tree then
        if self.view_range then self:sense() end
    end

    if self.on_brain_step then
        self:on_brain_step(dtime)
    end

	if self.behavior_tree and bt_mobs.exists(self.object) then
		if self.behavior_tree:is_finished() then
            self.behavior_tree:reset()
        end
        self.behavior_tree:run()
	end

	self.last_velocity = self.object:get_velocity()
	self.time_total = self.time_total+self.dtime
end

function bt_mobs.vitals(self)
	-- vitals: fall damage
	local vel = self.object:get_velocity()
	local velocity_delta = math_abs(self.last_velocity.y - vel.y)
	if velocity_delta > bt_mobs.safe_velocity then
		self.hp = self.hp - math_floor(self.max_hp * math_min(1, velocity_delta/bt_mobs.terminal_velocity))
	end
	
	-- vitals: breath
	if self.breath_max then
		local colbox = self.object:get_properties().collisionbox
		local headnode = bt_mobs.nodeatpos(
			bt_mobs.pos_shift(
				self.object:get_pos(),{y=colbox[5]}
			)
		) -- node at hitbox top
		if headnode and headnode.drawtype == 'liquid' then
			self.breath = self.breath - self.dtime
		else
			self.breath = self.breath_max
		end
			
		if self.breath <= 0 then self.hp=0 end	-- drown
	end
end

function bt_mobs.default_physics(self)
	local vel = self.object:get_velocity()

	if self.is_on_ground and not self.is_in_liquid then
		self.object:set_velocity({
			x = (vel.x > 0.2) and (vel.x*bt_mobs.friction) or 0,
			y = vel.y,
			z = (vel.z > 0.2) and (vel.z*bt_mobs.friction) or 0
		})
	end
	
	-- bounciness
	if self.springiness and self.springiness > 0 then
		local vnew = vector.new(vel)
		
		if not self.collided then						-- ugly workaround for inconsistent collisions
			for _,k in ipairs({'y','z','x'}) do

				if vel[k]==0 and math_abs(self.last_velocity[k]) > 0.1 then
					vnew[k] = -self.last_velocity[k] * self.springiness
				end
			end
		end
		
		if not vector.equals(vel,vnew) then
			self.collided = true
		else
			if self.collided then
				vnew = vector.new(self.last_velocity)
			end
			self.collided = false
		end
		
		self.object:set_velocity(vnew)
	end
	
	-- buoyancy
	local surface = nil
	local surfnodename = nil
	local spos = bt_mobs.get_stand_pos(self)
	spos.y = spos.y+0.01

	-- get surface height
	local snodepos = bt_mobs.get_node_pos(spos)
	local surfnode = bt_mobs.nodeatpos(spos)

	while surfnode and surfnode.drawtype == 'liquid' do
		surfnodename = surfnode.name
		surface = snodepos.y+0.5
		if surface > spos.y+self.height then break end
		snodepos.y = snodepos.y+1
		surfnode = bt_mobs.nodeatpos(snodepos)
	end
	self.is_in_liquid = surfnodename

	if surface then				-- standing in liquid
		local submergence = math_min(surface-spos.y,self.height)/self.height

		local buoyacc = bt_mobs.gravity*(self.buoyancy-submergence)
		bt_mobs.set_acceleration(self.object,{
			x = -vel.x * self.water_drag,
			y = buoyacc-vel.y * math_abs(vel.y)*0.4,
			z = -vel.z * self.water_drag
		})
	else
		self.object:set_acceleration({
			x = 0,
			y = bt_mobs.gravity,
			z = 0
		})
	end
end

function bt_mobs.default_on_brain_step(self)
	if bt_mobs.timer(self, 1) then bt_mobs.lava_hurt(self, 6) end
	bt_mobs.vitals(self)
	
	if self.hp <= 0 then
		self.object:remove()
		return
	end
end