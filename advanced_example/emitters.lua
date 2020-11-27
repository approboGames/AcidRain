local acidrain = require('acidrain.acidrain')

local M = {}

M.emitter_default = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		particle = {
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
	})
	return emitter
end

M.emitter_point = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "point",
			max_particles = 96,
		},
		particle = {
			emit_delay = 0.25,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			angle = {{0, 360}},
			velocity = {10},
		}

	})
	return emitter
end

M.emitter_rectangle = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "rectangle",
			width = 240,
			height = 160,
			max_particles = 64,
		},
		particle = {
			emit_delay = 0.05,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			angle = {{0, 360}},
			velocity = {5},
		}

	})
	return emitter
end

M.emitter_ellipse = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "ellipse",
			width = 240,
			height = 160,
			max_particles = 64,
		},
		particle = {
			emit_delay = 0.05,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			angle = {{0, 360}},
			velocity = {5},
		}

	})
	return emitter
end

M.emitter_rectangle_edge = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "rectangle_edge",
			width = 240,
			height = 160,
			max_particles = 64,
		},
		particle = {
			emit_delay = 0.05,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			angle = {{0, 360}},
			velocity = {5},
		}

	})
	return emitter
end

M.emitter_ellipse_edge = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "ellipse_edge",
			width = 240,
			height = 160,
			max_particles = 64,
		},
		particle = {
			emit_delay = 0.05,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			angle = {{0, 360}},
			velocity = {5},
		}

	})
	return emitter
end

M.emitter_angle = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_delay = 0.1,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "angle",
			angle = {{250, 290}},
			velocity = {100},
		}

	})
	return emitter
end

M.emitter_angle_seq = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_delay = 0.1,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "angle_seq",
			angle = {{1, 360}},
			angle_increment = 10,
			velocity = {120},
		}

	})
	return emitter
end

M.emitter_to_target = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "rectangle",
			width = 1,
			height = 240,
			max_particles = 64
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_delay = 0.1,
			time_in = 0.25,
			time_life = 1.75,
			time_out = 0.25,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "to_target",
			velocity = {45},
			target_position_x = 0,
			target_position_y = 0,
		}

	})
	return emitter
end

M.emitter_from_target = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "rectangle",
			width = 1,
			height = 240,
			max_particles = 64
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_delay = 0.1,
			time_in = 0.25,
			time_life = 1.75,
			time_out = 0.25,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "from_target",
			velocity = {45},
			target_position_x = 0,
			target_position_y = 0,
		}

	})
	return emitter
end

M.emitter_custom_func = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_delay = 0.125,
			time_in = 0.25,
			time_life = 3.25,
			time_out = 0.25,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "custom_func",
			custom_func = function()
				local math_sin = math.sin
				local math_rad = math.rad

				local amplitude = 200
				local sin_angle = 90
				local inc_angle = 4

				local M = {}

				M.update = function(velocity, angle)
					velocity_x = math_sin(math_rad(sin_angle)) * amplitude
					velocity_y = velocity

					amplitude = amplitude + 2
					sin_angle = sin_angle + inc_angle
					if sin_angle > 360 then sin_angle = 1 end

					return velocity_x, velocity_y;
				end

				return M
			end,
			velocity = {70},
		}

	})
	return emitter
end

M.emitter_inout_easing = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "point",
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			alpha_in = 0.25,
			alpha_life = 1,
			alpha_out = 0.25,
			time_in = 1.5,
			time_life = 1,
			time_out = 1,
			scale_in = vmath.vector3(0.1, 0.1, 0.1),
			scale_life = vmath.vector3(4, 4, 4),
			scale_out = vmath.vector3(0.25, 0.25, 0.25),
			scale_in_easing = go.EASING_OUTBOUNCE,
			scale_out_easing = go.EASING_INBACK,
		},
		movement = {
			angle = {{240, 290}},
			velocity = {60},
		}

	})
	return emitter
end

M.emitter_multiple_per_emit = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_qty = 6,
			emit_delay = 0.5,
			time_in = 0.25,
			time_life = 1,
			time_out = 0.5,
			scale_in = vmath.vector3(0.1, 0.1, 0.1),
			scale_life = vmath.vector3(3, 3, 3),
			scale_out = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "angle_seq",
			angle = {{1, 360}},
			angle_increment = 10,
			velocity = {150},
		}

	})
	return emitter
end

M.emitter_animation = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_emoji",
			sprite_id = "sprite",
		},
		emitter = {
			type = "point",
			parent_space = true,
		},
		particle = {
			emit_delay = 0.75,
			alpha_in = 1,
			alpha_life = 1,
			alpha_out = 0.25,
			time_in = 1,
			time_life = 2,
			time_out = 1,
			scale_in = vmath.vector3(0.1, 0.1, 0.1),
			scale_life = vmath.vector3(2.5, 2.5, 2.5),
			scale_out = vmath.vector3(0.25, 0.25, 0.25),
			scale_in_easing = go.EASING_OUTBACK,
			scale_out_easing = go.EASING_INBACK,
			animation_in = {"1"},
			animation_life = {"2", "5", "6", "8", "9", "10", "11", "12"},
			animation_out = {"3", "4", "7"},
		},
		movement = {
			angle = {{220, 310}},
			velocity = {50},
		}

	})
	return emitter
end

M.emitter_angle_bounce = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_delay = 0.1,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "angle_seq",
			angle = {{220, 320}},
			angle_increment = 10,
			angle_bounce = true,
			velocity = {120},
		}

	})
	return emitter
end


M.emitter_rotate_to_direction = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_delay = 0.1,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "angle_seq",
			angle = {{220, 320}},
			angle_increment = 10,
			angle_bounce = true,
			rotate_to_direction = true,
			velocity = {120},
		}

	})
	return emitter
end

M.emitter_velocity_adjust = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "point",
			max_particles = 96
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_qty = 32,
			emit_delay = 2,
			time_in = 0.5,
			time_life = 1.5,
			time_out = 0.5,
		scale_in = vmath.vector3(0.1, 0.1, 0.1),
		scale_life = vmath.vector3(3, 3, 3),
		scale_out = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "angle_seq",
			angle = {{1, 360}},
			angle_increment = 12,
			velocity = {300},
			velocity_adjust_x = 0.97,
			velocity_adjust_y = 0.97,
		}
	})
	return emitter
end

M.emitter_gravity_xy = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			type = "point",
			max_particles = 96
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_delay = 0.1,
			time_in = 0.25,
			time_life = 2,
			time_out = 0.75,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
			scale_life = vmath.vector3(1, 1, 1),
			scale_out = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			angle = {{260, 280}},
			velocity = {300},
			gravity_x = -1,
			gravity_y = -4,
		}

	})
	return emitter
end

M.emitter_update_per_frame = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		particle = {
			emit_delay = 0.5,
			time_in = 0.25,
			time_life = 1.25,
			time_out = 0.25,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			angle = {{240, 290}},
			velocity = {100},
		},
	})
	return emitter
end

M.emitter_update_transition = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star",
			sprite_id = "sprite",
		},
		emitter = {
			update_method = "transition",
		},
		particle = {
			emit_delay = 0.5,
			time_in = 0.25,
			time_life = 2,
			time_out = 0.25,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			movement_easing = go.EASING_INOUTBACK,
			angle = {{240, 290}},
			velocity = {60},
		},
	})
	return emitter
end

M.emitter_update_physics = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_star_dynamic",
			sprite_id = "sprite",
			collisionobject_id = "collisionobject"
		},
		emitter = {
			update_method = "physics",
			type = "point",
			width = 320,
			height = 1,
			max_particles = 100
		},
		particle = {
			color = {vmath.vector3(1, 1, 1)},
			emit_delay = 0.025,
			time_in = 0.25,
			time_life = 2,
			time_out = 0.25,
			scale_in = vmath.vector3(0.25, 0.25, 0.25),
		},
		movement = {
			type = "angle",
			angle = {{250, 290}},
			velocity = {180},
			angle_increment = 4,
			angle_bounce = true,
		}

	})
	return emitter
end

M.emitter_flame = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_blob_large",
			sprite_id = "sprite",
		},
		emitter = {
			type = "point",
		},
		particle = {
			color = {vmath.vector3(1, 0, 0), vmath.vector3(1, 1, 0)},
			emit_qty = 2,
			emit_delay = 0.1,
			time_in = 0.1,
			time_life = 0.25,
			time_out = 1.25,
			scale_in = vmath.vector3(0.3, 0.3, 0.3),
			scale_life = vmath.vector3(1, 1, 1),
			scale_out = vmath.vector3(0, 0, 0),
		},
		movement = {
			type = "angle",
			angle = {{260, 280}},
			velocity = {{60, 100}},
			gravity_y = 1,
		}
	})
	return emitter
end

M.emitter_aurora = function()
	local emitter = acidrain.create({
		factory = {
			url = "/go#factory_blob_large",
			sprite_id = "sprite",
		},
		emitter = {
			type = "rectangle",
			width = 320,
			height = 1,
		},
		particle = {
			color = {vmath.vector3(1, 0.5, 0.5), vmath.vector3(0.5, 1, 0.5), vmath.vector3(0.5, 0.5, 1)},
			emit_qty = 1,
			emit_delay = 0.25,
			alpha_in = 0,
			alpha_life = 0.35,
			alpha_out = 0,
			time_in = 2,
			time_life = 1,
			time_out = 4,
			scale_in = vmath.vector3(0.2, 0.4, 0.2),
			scale_life = vmath.vector3(2, 2.5, 2),
			scale_out = vmath.vector3(0, 0, 0),
		},
		movement = {
			type = "angle",
			angle = {1, 180},
			velocity = {{10, 40}},
		}
	})
	return emitter
end

return M