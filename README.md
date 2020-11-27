# Acid Rain

**A single file pure Lua particle system for Defold.**

**Acid Rain uses Factories and Game objects for particle creation. This allows the use of Flip book animation (in/life/out and multipe sprites per emitter), per frame/easing/physics movement, in/out easing and collision objects!**

---

# Installation

Simpy download **acidrain.lua** and add it to your project. Then include it in any script you wish to use it to create emitters (standard Lua stuff).

```
local acidrain = require('acidrain')
```

# Usage
```
function init(self)
	self.emitter = acidrain.create({
		factory = {
			url = "/go#factory",
			sprite_id = "sprite",
		},
	})
	self.emitter.start()
end

function update(self, dt)
	self.emitter.update(dt)
end
```

This will create and start an emitter with default parameters. Minimally you need to specify:
* The URL of a Factory component to spawn particles
* The Id (Not URL) of a sprite component contained in the Game object (prototype) used in the above Factory


# Acid Rain API

*Don't be put off by the amount of parameters. Start with the above example and add parameters as required.  It's much easier than it looks! There's lots of examples in the example project and also a minimal example project with a single default emitter.*

## Functions

### acidrain.create(config)
Create an Acid Rain emitter instance. **The emitter will spawn particles relative to the position of the Game object containing the script which creates the emitter.**

#### PARAMETERS

* `config` **[table]**
  * `factory` **[table]** - Table of factory parameters (REQUIRED)
    * `factory_url` **[hash]** - URL of a Factory component to spawn particles (REQUIRED)
	* `sprite_id` **[hash]** - The Id (Not URL) of a sprite component contained in the Game object (prototype) used in the above Factory (REQUIRED)
	* `collisionobject_id` **[hash]** - The Id (Not URL) of a collision object contained in the Game object (prototype) used in the above Factory (OPTIONAL)
  * `emitter` **[table]** - Table of emitter parameters (OPTIONAL)
    * `update_method` **[hash]** - How the emitter should update particles `per_frame`, `transition`, `physics` (SEE BELOW)
	* `type` **[hash]** - Emitter shape `point`, `rectangle`, `ellipse`, `rectangle_edge`, `ellipse_edge`
	* `width` **[number]** - Emitter width in pixels
	* `height` **[number]** - Emitter height in pixels
	* `offset_x` **[number]** - X offset in pixels relative to the containing Game object
	* `offset_y` **[number]** - Y offset in pixels relative to the containing Game object
	* `max_particles` **[number]** - Max number of particles allowed on screen
	* `parent_space` **[boolean]** - `true` Occupy the geometric space of the containing Game object, `false` Occupy world space
  * `particle` **[table]** - Table of particle parameters (OPTIONAL)
    * `color` **[table]** - Table containing one or more `vmath.vector3` RGB values
	* `emit_qty` **[number]** - Number of particles to emit per emission
	* `emit_delay` **[number]** - Time in seconds between emissions
	* `emit_repeat` **[number]** - Number of emissions to perform, `0` for unlimited
	* `time_in` **[number]** - Time in seconds to ease in
	* `time_life` **[number]** - Life time in seconds
	* `time_out` **[number]** - Time is seconds to ease out
	* `alpha_in` **[number]** - Start particle alpha - transitions to `alpha_life` over `time_in`
	* `alpha_life` **[number]** - Life particle alpha - constant for duration of `time_life`
	* `alpha_out` **[number]** - End particle alpha - transitions from `alpha_life` over `time_out`
	* `alpha_in_easing` **[hash]** - Alpha in easing method, for example `go.EASING_LINEAR`
	* `alpha_out_easing` **[hash]** - Alpha out easing method
	* `scale_in` **[vmath.vector3]** - Start particle scale - transitions to `scale_life` over `time_in`
	* `scale_life` **[vmath.vector3]** - Life particle scale - constant for duration of `time_life`
	* `scale_out` **[vmath.vector3]** - End particle scale - transitions from `scale_life` over `time_out`
	* `scale_in_easing` **[hash]** - Scale in easing method, for example `go.EASING_LINEAR`
	* `scale_out_easing` **[hash]** - Scale out easing method, for example `go.EASING_LINEAR`
	* `animation_in` **[table]** - Table containing one or more Animation Id's to play during `time_in`
	* `animation_life` **[table]** - Table containing one or more Animation Id's to play during `time_life`
	* `animation_out` **[table]** - Table containing one or more Animation Id's to play during `time_out`
  * `movement` **[table]** - Table of movement parameters (OPTIONAL)
    * `type` **[hash]** - `none`, `angle`, `angle_seq`, `to_target`, `from_target`, `custom_func`
	* `custom_func` **[function]** - Move particles using a custom function (See Custom Function section)
	* `angle` **[table]** - Table containing one or more angles to emit on (See below)
	* `angle_increment` **[number]** - Increment select value from `angle` table by amount
	* `angle_bounce` **[boolean]** - Bounce up and down the `angle` table
	* `rotate_to_direction` **[boolean]** - Rotate particles to orient to direction of travel
	* `velocity` **[table]** - Table containing one or more emit velocities (See below)
	* `velocity_adjust_x` **[number]** - Multiply X velocity by amount each frame
	* `velocity_adjust_y` **[number]** - Multiply Y velocity by amount each frame
	* `gravity_x` **[number]** - Add amount to X velocity each frame
	* `gravity_y` **[number]** - Add amount to Y velocity each frame
	* `target_position_x` **[number]** - Particle target X position
	* `target_position_y` **[number]** - Particle target Y position
	* `transition_overrun` **[number]** - Amount to over run particle target positions in seconds

#### UPDATE METHODS PARAMETER
Acid Rain emitters can use one of three methods to update particle positions over the lifetime of a particle using the `update_method` parameter. These are:
* `per_frame` - Particle position is calculated on a frame by frame basis, this is the default method
* `transition` - Start and destination positions are calculated for each particle then particle position is updated using Defolds easing functions
* `physics` - Angle and force are calculated and applied to each particle on creation then particle position is updated by Defolds Physics System (Game objects require Dynamic collision objects)

#### COLLISION OBJECTS
Collision objects can be added to any Factory Game objects used for particle creation regardless of update method but only the `physics` update method should us Dynamic objects. `per_frame` and `transition` update methods would normally use Kinematic objects.

#### ADDITIONAL PARAMETER INFO
* Tables with multiple values - Acid Rain will randomly choose a different value for each emit
* The `angle` and `velocity` parameter tables can be formatted as follows
  * `{1}` - Single value - **1**
  * `{1, 5, 10}` - Multiple individual values - **1, 5 and 10**
  * `{{5, 10}}` - Multiple between values - **5, 6, 7, 8, 9, 10**
  * `{1, 2, {5, 10}}` - Combination of values - **1, 2, 5, 6, 7, 8, 9, 10**

#### CUSTOM FUNCTION PARAMETER
Normally Acid Rain will calculate the x and y velocities for each particle on a frame by frame basis. Particle movement can also be calculated using a custom function.


The custom function should define and return a table `M = {}` with an `M.update()` function that Acid Rain will call once per particle per frame.

```
-- Blank custom function template
function()
	-- Define local vars here

	local M = {}
	M.update = function(velocity, angle, velocity_adjust_x, velocity_adjust_y, gravity_x, gravity_y)
		-- Calculate velocites here

		return velocity_x, velocity_y
	end
	return M
end
```

The following parameters from your emitter will be passed to `M.update()` each frame - `velocity`, `angle`, `velocity_adjust_x`, `velocity_adjust_y`, `gravity_x`, `gravity_y`

`M.update()` should then calculate and return `velocity_x` and `velocity_y`


Also see the **Default Values** section below. The default function exactly replicates the standard `per_frame` velocity calculations done by Acid Rain.

### acidrain.update(dt)
Update the emitter. This should be called every frame to update active and remove inactive particles.

#### PARAMETERS

* `dt` **[number]** - Delta time

### acidrain.emit()
Perform a single emission. This will be however many particles are set in the `emit_qty` parameter.

### acidrain.start()
Start the emitter. The emitter will continue until the `emit_repeat` parameter is reached.

### acidrain.stop()
Stop the emitter. Particles already emitted will continue normally until the end of their life. Use `acidrain.clean()` immediately after if you also want to remove particles.

### acidrain.clean()
Immediately remove all active particles. This will not stop the emitter which will continue to spawn new particles.

### acidrain.calculate_angles()
Recalculate the emitter angles table after changing the `angle` parameter (See Modifying emitters below)

### acidrain.calculate_velocities()
Recalculate the emitter velocities table after changing the `velocity` parameter (See Modifying emitters below)

### acidrain.iterate()
Iterate over existing particles (See Modifying emitters below)

```
for particle in self.emitter.iterate() do
	-- Do something to each particle
end
```

# Modifying emitters

Both emitters and particle parameters can be modified in real time with the exception of the `factory = {}` parameter table.

**To modify emitter settings for new particles:**

```
-- emitter_name.parameter = x

self.emitter.emitter.width = 100
self.emitter.particle.emit_qty = 8
self.emitter.movement.angle = {90)
self.emitter.movement.velocity = {120}
```

*Note: Emitter angles and velocities are pre-calculated for efficiency. Any changes to the `angle` and `velocity` parameters will require recalculation using the following functions respectively before changes will take effect:*

```
acidrain.calculate_angles()
acidrain.calculate_velocities()
```

**To modify already spawned particles:**

```
for particle in self.emitter.iterate() do
	-- Do something to each particle, the following properties are available
		-- particle.velocity - Use particle.calculate_velocites() after changing
		-- particle.angle - Use particle.calculate_velocites() after changing
		-- particle.active
		-- particle.go_url
		-- particle.sprite_url
		-- particle.collision_url
		-- particle.game_object

	-- Example (Tint the particle red)
	local cur_color = go.get(particle.sprite_url, "tint")
	go.set(particle.sprite_url, "tint", vmath.vector4(1, 0, 0, cur_color.w))

	-- Example (Immediately delete the particle)
	particle.active = false
end
```

# Default values

An example of creating an emitter with all the default values for reference.
```
self.emitter = acidrain.create({
	factory = {
		url = false,
		sprite_id = false,
		collisionobject_id = false
	},
	emitter = {
		type = "point"
		width = 32,
		height = 32,
		offset_x = 0,
		offset_y = 0,
		max_particles = 32,
		parent_space = false
	},
	particle = {
		color = {vmath.vector3(1, 1, 1)},
		emit_qty = 1,
		emit_delay = 0.5,
		emit_repeat = 0,
		alpha_in = 0,
		alpha_life = 1,
		alpha_out = 0,
		alpha_in_easing = go.EASING_LINEAR,
		alpha_out_easing = go.EASING_LINEAR,
		time_in = 0.5,
		time_life = 1,
		time_out = 0.5,
		scale_in = vmath.vector3(1, 1, 1),
		scale_life = vmath.vector3(1, 1, 1),
		scale_out = vmath.vector3(1, 1, 1),
		scale_in_easing = go.EASING_LINEAR,
		scale_out_easing = go.EASING_LINEAR,
		animation_in = false,
		animation_life = false,
		animation_out = false,
	},
	movement = {
		type = "angle",
		custom_func =
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
		angle = {270},
		angle_increment = 10,
		angle_bounce = false,
		rotate_to_direction = false,
		velocity = {100},
		velocity_adjust_x = 1,
		velocity_adjust_y = 1,
		gravity_x = 0,
		gravity_y = 0,
		target_position_x = 0,
		target_position_y = 0,
		transition_overrun = 0,
	}
})
```
