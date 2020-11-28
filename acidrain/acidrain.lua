--[[
MIT License

Copyright (c) 2020 AppRobo Games

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]


-- Acid Rain - Lua particle system for Defold
local M = {}

function M.create(config)
	assert(config, "You must provide a config")
	assert(config.factory, "You must provide a factory config")
	assert(config.factory.url, "You must provide a factory url")
	assert(config.factory.sprite_id, "You must provide a sprite id")

	if config.emitter == nil then config.emitter = {} end
	if config.particle == nil then config.particle = {} end
	if config.movement == nil then config.movement = {} end

	-- Localize
	local math_random, math_sin, math_cos, math_rad, math_sqrt = math.random, math.sin, math.cos, math.rad, math.sqrt

	-- Non adjustable vars
	local factory_url = config.factory.url
	local sprite_id = config.factory.sprite_id
	local collisionobject_id = config.factory.collisionobject_id or false
	local update_method = config.emitter.update_method or "per_frame"-- per_frame, transition, physics

	local pos_z_inc = 0
	local pos_z_step = 0.000001
	local pos_z_max = 0.001
	local emit_timer = false
	local angle_seq_id = 1
	local angle_seq_dir = 1
	local emitted_qty = 0

	local angles = {}
	local velocities = {}

	-- Public instance
	local AR = {
		emitter = {
			type = config.emitter.type or "point", -- point, rectangle, ellipse, rectangle_edge, ellipse_edge
			width = config.emitter.width or 32,
			height = config.emitter.height or 32,
			offset_x = config.emitter.offset_x or 0,
			offset_y = config.emitter.offset_y or 0,
			max_particles = config.emitter.max_particles or 32,
			parent_space = config.emitter.parent_space or false
		},
		particle = {
			color = config.particle.color or {vmath.vector3(1, 1, 1)},
			emit_qty = config.particle.emit_qty or 1,
			emit_delay = config.particle.emit_delay or 0.5,
			emit_repeat = config.particle.emit_repeat or 0,
			alpha_in = config.particle.alpha_in or 0,
			alpha_life = config.particle.alpha_life or 1,
			alpha_out = config.particle.alpha_out or 0,
			alpha_in_easing = config.particle.alpha_in_easing or go.EASING_LINEAR,
			alpha_out_easing = config.particle.alpha_out_easing or go.EASING_LINEAR,
			time_in = config.particle.time_in or 0.5,
			time_life = config.particle.time_life or 1,
			time_out = config.particle.time_out or 0.5,
			scale_in = config.particle.scale_in or vmath.vector3(1, 1, 1),
			scale_life = config.particle.scale_life or vmath.vector3(1, 1, 1),
			scale_out = config.particle.scale_out or vmath.vector3(1, 1, 1),
			scale_in_easing = config.particle.scale_in_easing or go.EASING_LINEAR,
			scale_out_easing = config.particle.scale_out_easing or go.EASING_LINEAR,
			animation_in = config.particle.animation_in or false,
			animation_life = config.particle.animation_life or false,
			animation_out = config.particle.animation_out or false,
		},
		movement = {
			type = config.movement.type or "angle", -- none, angle, angle_seq, to_target, from_target, custom_func
			custom_func = config.movement.custom_func or
				function()
					local math_sin, math_cos, math_rad = math.sin, math.cos, math.rad
					local velocity_adjust_inc_x, velocity_adjust_inc_y = 1, 1
					local gravity_inc_x, gravity_inc_y = 1, 1

					local M = {}
					M.update = function(velocity, angle, velocity_adjust_x, velocity_adjust_y, gravity_x, gravity_y)
						velocity_adjust_inc_x = velocity_adjust_inc_x * velocity_adjust_x
						velocity_adjust_inc_y = velocity_adjust_inc_y * velocity_adjust_y
						gravity_inc_x = gravity_inc_x + gravity_x
						gravity_inc_y = gravity_inc_y + gravity_y

						velocity_x = velocity * math_cos(-math_rad(angle)) * velocity_adjust_inc_x + gravity_inc_x
						velocity_y = velocity * math_sin(-math_rad(angle)) * velocity_adjust_inc_y + gravity_inc_y

						return velocity_x, velocity_y
					end
					return M
				end,
			angle = config.movement.angle or {270},
			angle_increment = config.movement.angle_increment or 10,
			angle_bounce = config.movement.angle_bounce or false,
			rotate_to_direction = config.movement.rotate_to_direction or false,
			velocity = config.movement.velocity or {100},
			velocity_adjust_x = config.movement.velocity_adjust_x or 1,
			velocity_adjust_y = config.movement.velocity_adjust_y or 1,
			movement_easing = config.movement.movement_easing or go.EASING_LINEAR,
			gravity_x = config.movement.gravity_x or 0,
			gravity_y = config.movement.gravity_y or 0,
			target_position_x = config.movement.target_position_x or 0,
			target_position_y = config.movement.target_position_y or 0,
			transition_overrun = config.movement.transition_overrun or 0 -- TO IMPLEMENT
		}
	}

	AR.particles = {}

	-- Build single particle
	AR.build = function()
		-- Create
		local particle = {
			game_object = factory.create(factory_url, nil, nil, nil, AR.particle.scale_in),
			active = true
		}
		table.insert(AR.particles, particle)

		particle.go_url = msg.url(nil, particle.game_object, nil)
		particle.sprite_url = msg.url(nil, particle.game_object, sprite_id)

		if collisionobject_id then
			particle.collision_url = msg.url(nil, particle.game_object, collisionobject_id)
		else
			particle.collision_url = false
		end

		-- Color
		local color = AR.particle.color[math_random(#AR.particle.color)]
		go.set(particle.sprite_url, "tint", vmath.vector4(color.x, color.y, color.z, AR.particle.alpha_in))

		-- Position
		local emitter_pos = go.get_position()
		local particle_init_pos = go.get_position(particle.game_object)
		if AR.emitter.type == "point" then
			go.set(particle.game_object, "position", vmath.vector3(
				emitter_pos.x + AR.emitter.offset_x,
				emitter_pos.y + AR.emitter.offset_y,
				particle_init_pos.z + pos_z_inc
			))
		elseif AR.emitter.type == "rectangle" then
			go.set(particle.game_object, "position", vmath.vector3(
				emitter_pos.x + AR.emitter.offset_x + math_random(-(AR.emitter.width / 2), AR.emitter.width / 2),
				emitter_pos.y + AR.emitter.offset_y + math_random(-(AR.emitter.height / 2), AR.emitter.height / 2),
				particle_init_pos.z + pos_z_inc
			))
		elseif AR.emitter.type == "ellipse" then
			local rho = math_random()
			local phi = (math_random(0, 200) * 0.01) * math.pi
			local x = math_sqrt(rho) * math_cos(phi) * (AR.emitter.width * 0.5)
			local y = math_sqrt(rho) * math_sin(phi) * (AR.emitter.height * 0.5)

			go.set(particle.game_object, "position", vmath.vector3(
				emitter_pos.x + AR.emitter.offset_x + x,
				emitter_pos.y + AR.emitter.offset_y + y,
				particle_init_pos.z + pos_z_inc
			))
		elseif AR.emitter.type == "rectangle_edge" then
			local x, y
			local unfolded_pos = math_random(0, (AR.emitter.width * 2) + (AR.emitter.height * 2))
			if unfolded_pos <= AR.emitter.width then
				x = unfolded_pos; y = 0
			elseif unfolded_pos > AR.emitter.width and unfolded_pos <= AR.emitter.width + AR.emitter.height then
				x = AR.emitter.width; y = -(unfolded_pos - AR.emitter.width)
			elseif unfolded_pos > AR.emitter.width + AR.emitter.height and unfolded_pos <= (AR.emitter.width * 2) + AR.emitter.height then
				x = AR.emitter.width - (unfolded_pos - AR.emitter.width - AR.emitter.height); y = -(AR.emitter.height)
			elseif unfolded_pos > (AR.emitter.width * 2) + AR.emitter.height and unfolded_pos <= (AR.emitter.width * 2) + (AR.emitter.height * 2) then
				x = 0; y = -(AR.emitter.height) + (unfolded_pos - (AR.emitter.width * 2) - AR.emitter.height)
			end

			go.set(particle.game_object, "position", vmath.vector3(
				emitter_pos.x + AR.emitter.offset_x - (AR.emitter.width * 0.5) + x,
				emitter_pos.y + AR.emitter.offset_y + (AR.emitter.height * 0.5) + y,
				particle_init_pos.z + pos_z_inc
			))
		elseif AR.emitter.type == "ellipse_edge" then
			local angle = math_random(1, 360)
            x = (AR.emitter.width / 2) * math_sin(math_rad(angle))
			y = (AR.emitter.height / 2) * math_cos(math_rad(angle))

			go.set(particle.game_object, "position", vmath.vector3(
				emitter_pos.x + AR.emitter.offset_x + x,
				emitter_pos.y + AR.emitter.offset_y + y,
				particle_init_pos.z + pos_z_inc
			))
		end

		-- Increment z position for next particle
		pos_z_inc = pos_z_inc + pos_z_step
		if pos_z_inc > pos_z_max then pos_z_inc = 0 end

		-- Angle
		local parent_angle
		if AR.emitter.parent_space == true then
			parent_angle = 0
			go.set_parent(particle.game_object, go.get_id(), 1)
		else
			parent_angle = go.get(go.get_id(), "euler.z")
		end

		if AR.movement.type == "none" then
			particle.angle = 0
		elseif AR.movement.type == "angle" or AR.movement.type == "custom_func"  then
			particle.angle = angles[math_random(#angles)] - parent_angle
		elseif AR.movement.type == "angle_seq" then
			particle.angle = angles[angle_seq_id] - parent_angle

			if angle_seq_dir == 1 then
				angle_seq_id = angle_seq_id + AR.movement.angle_increment
				if angle_seq_id > #angles then
					if AR.movement.angle_bounce == true then
						angle_seq_id = angle_seq_id - AR.movement.angle_increment
						angle_seq_dir = 0
					else
						angle_seq_id = 1
					end
				end
			elseif angle_seq_dir == 0 then
				angle_seq_id = angle_seq_id - AR.movement.angle_increment
				if angle_seq_id < 1 then
					if AR.movement.angle_bounce == true then
						angle_seq_id = angle_seq_id + AR.movement.angle_increment
						angle_seq_dir = 1
					else
						angle_seq_id = 1
					end
				end
			end
		end

		-- Rotate to direction
		if AR.movement.rotate_to_direction == true then
			go.set(particle.game_object, "euler.z", 270 - particle.angle)
		end

		-- Particle should be in start position (used below)
		local particle_start_pos = go.get_position(particle.game_object)

		-- Velocities
		if AR.movement.type == "none" then
			particle.velocity = 0
			particle.velocity_x = 0
			particle.velocity_y = 0
		elseif AR.movement.type == "angle" or AR.movement.type == "angle_seq" then
			particle.velocity = velocities[math_random(#velocities)]
			particle.velocity_x = particle.velocity * math_cos(-math_rad(particle.angle))
			particle.velocity_y = particle.velocity * math_sin(-math_rad(particle.angle))
		elseif AR.movement.type == "to_target" then
			particle.velocity = velocities[math_random(#velocities)]
			particle.velocity_x = (AR.movement.target_position_x - particle_start_pos.x) * (particle.velocity / 100)
			particle.velocity_y = (AR.movement.target_position_y - particle_start_pos.y) * (particle.velocity / 100)
		elseif AR.movement.type == "from_target" then
			particle.velocity = velocities[math_random(#velocities)]
			particle.velocity_x = (particle_start_pos.x - AR.movement.target_position_x) * (particle.velocity / 100)
			particle.velocity_y = (particle_start_pos.y - AR.movement.target_position_y) * (particle.velocity / 100)
		elseif AR.movement.type == "custom_func" then
			particle.custom_func = AR.movement.custom_func()
			particle.velocity = velocities[math_random(#velocities)]
		end

		-- Transition destinations
		if update_method == "transition" then
			if AR.movement.type == "none" then
				particle.destination_x = particle_start_pos.x
				particle.destination_y = particle_start_pos.y
			else
				particle.destination_x = particle_start_pos.x + (particle.velocity_x * (AR.particle.time_in + AR.particle.time_life + AR.particle.time_out))
				particle.destination_y = particle_start_pos.y + (particle.velocity_y * (AR.particle.time_in + AR.particle.time_life + AR.particle.time_out))
			end
		end

		-- Animate movements
		if update_method == "transition" then
			local particle_start_pos = go.get_position(particle.game_object) -- Required for updated z pos and single transition
			go.animate(particle.game_object, "position", go.PLAYBACK_ONCE_FORWARD, vmath.vector3(particle.destination_x, particle.destination_y, particle_start_pos.z), AR.movement.movement_easing, AR.particle.time_in + AR.particle.time_life + AR.particle.time_out)
		elseif update_method == "physics" then
			msg.post(particle.collision_url, "apply_force", {force = vmath.vector3(particle.velocity_x * particle.velocity, particle.velocity_y * particle.velocity, 0), position = go.get_position()})
		end

		-- Animate lifetimes
		local particle_done = function()
			particle.active = false
		end

		local particle_out = function()
			if AR.particle.animation_out then
				local animation_out = AR.particle.animation_out[math_random(#AR.particle.animation_out)]
				msg.post(particle.sprite_url, "play_animation", {id = hash(animation_out)})
			end
			go.animate(particle.sprite_url, "tint.w", go.PLAYBACK_ONCE_FORWARD, AR.particle.alpha_out, AR.particle.alpha_out_easing, AR.particle.time_out, 0, particle_done)
			go.animate(particle.sprite_url, "scale", go.PLAYBACK_ONCE_FORWARD, AR.particle.scale_out, AR.particle.scale_out_easing, AR.particle.time_out)
		end

		local particle_life = function()
			if AR.particle.animation_life then
				local animation_life = AR.particle.animation_life[math_random(#AR.particle.animation_life)]
				msg.post(particle.sprite_url, "play_animation", {id = hash(animation_life)})
			end
			-- This transition seems unnecessary but is less error prone than using a timer to trigger an action on a deleted particle
			go.animate(particle.sprite_url, "scale", go.PLAYBACK_ONCE_FORWARD, AR.particle.scale_life, go.EASING_LINEAR, AR.particle.time_life, 0, particle_out)
		end

		if AR.particle.animation_in then
			local animation_in = AR.particle.animation_in[math_random(#AR.particle.animation_in)]
			msg.post(particle.sprite_url, "play_animation", {id = hash(animation_in)})
		end
		go.animate(particle.sprite_url, "tint.w", go.PLAYBACK_ONCE_FORWARD, AR.particle.alpha_life, AR.particle.alpha_in_easing, AR.particle.time_in, 0, particle_life)
		go.animate(particle.sprite_url, "scale", go.PLAYBACK_ONCE_FORWARD, AR.particle.scale_life, AR.particle.scale_in_easing, AR.particle.time_in)

		particle.calculate_velocites = function()
			particle.velocity_x = particle.velocity * math_cos(-math_rad(particle.angle))
			particle.velocity_y = particle.velocity * math_sin(-math_rad(particle.angle))
		end
	end

	-- Angles precalculate
	AR.calculate_angles = function()
		for i = 1, #AR.movement.angle do
			if type(AR.movement.angle[i]) == "table" then
				if AR.movement.angle[i][1] < AR.movement.angle[i][2] then
					for i = AR.movement.angle[i][1], AR.movement.angle[i][2] do
						table.insert(angles, i)
					end
				elseif AR.movement.angle[i][1] > AR.movement.angle[i][2] then
					for i = AR.movement.angle[i][1], AR.movement.angle[i][2], -1 do
						table.insert(angles, i)
					end
				end
			else
				table.insert(angles, AR.movement.angle[i])
			end
		end
	end

	-- Velocities precalculate
	AR.calculate_velocities = function()
		for i = 1, #AR.movement.velocity do
			if type(AR.movement.velocity[i]) == "table" then
				for i = AR.movement.velocity[i][1], AR.movement.velocity[i][2] do
					table.insert(velocities, i)
				end
			else
				table.insert(velocities, AR.movement.velocity[i])
			end
		end
	end

	-- Update particles
	AR.update = function(dt)
		for i = #AR.particles, 1, -1 do
			local particle = AR.particles[i]
			if particle.active == true then
				if update_method == "per_frame" then
					if AR.movement.type == "custom_func" then
						particle.velocity_x, particle.velocity_y = particle.custom_func.update(particle.velocity, particle.angle, AR.movement.velocity_adjust_x, AR.movement.velocity_adjust_y, AR.movement.gravity_x, AR.movement.gravity_y)
					else
						particle.velocity_x = particle.velocity_x * AR.movement.velocity_adjust_x + AR.movement.gravity_x
						particle.velocity_y = particle.velocity_y * AR.movement.velocity_adjust_y + AR.movement.gravity_y
					end

					local pos = go.get_position(particle.game_object)
					pos.x = pos.x + (particle.velocity_x * dt)
					pos.y = pos.y + (particle.velocity_y * dt)
					go.set_position(pos, particle.game_object)
				end
			else
				go.delete(particle.game_object)
				table.remove(AR.particles, i)
			end
		end
	end

	-- Single emit
	AR.emit = function()
		for i = 1, AR.particle.emit_qty do
			if #AR.particles < AR.emitter.max_particles then
				AR.build()
			end
		end

		emitted_qty = emitted_qty + 1
		if AR.particle.emit_repeat ~= 0 and emitted_qty == AR.particle.emit_repeat then
			AR.stop()
		end
	end

	-- Start emitter
	AR.start = function()
		AR.stop()
		AR.emit()
		emit_timer = timer.delay(AR.particle.emit_delay, true, function()
			AR.emit()
		end)
	end

	-- Stop emitter
	AR.stop = function()
		if emit_timer then timer.cancel(emit_timer) end
		emit_timer = false
		emitted_qty = 0
	end

	-- Clean emitter
	AR.clean = function()
		for i = #AR.particles, 1, -1 do
			local particle = AR.particles[i]
			go.delete(particle.game_object)
			table.remove(AR.particles, i)
		end
	end

	-- Interate particles
	AR.iterate = function()
		local i = #AR.particles
		return function()
			local particle = AR.particles[i]
			i = i - 1

			return particle
		end

	end

	AR.calculate_angles()
	AR.calculate_velocities()

	return AR
end

return M
