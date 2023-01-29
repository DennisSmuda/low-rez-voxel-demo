extends CharacterBody3D

@onready var mesh: MeshInstance3D = $Mesh
@onready var back_splash_particles = $BackSplashParticles

var speed = 10
var steer_target = 0 # -1 to 1 range
var accelleration = 0 # -1 to 1 range

var front_body = null
var left_body = null
var right_body = null

var ceg = Vector3.ZERO
var front_height = 0
var left_height = 0
var right_height = 0
var back_height = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = null

	steer_target = 3 * (Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))

	if Input.is_action_just_pressed("move_up"):
		accelleration += 0.01

	if Input.is_action_just_pressed("move_down"):
		accelleration -= 0.01

	accelleration = min(accelleration, 0.5)
	accelleration = max(accelleration, 0)

	velocity = transform.basis.z * speed * delta * accelleration


	collision = move_and_collide(velocity)
	rotate(Vector3.UP, steer_target * delta)
	
	if velocity.length() > 0.002:
		back_splash_particles.emitting = true
	else:
		back_splash_particles.emitting = false
	
	if (collision):
		print("Collision", collision)


func update_water_levels(noise: FastNoiseLite, counter: float):
	var facing_dir = transform.basis.z
	var boat_to_cell_pos = Vector2i(int(position.x * 2.5), int(position.z * 2.5))

	var boat_height = noise.get_noise_3d(boat_to_cell_pos.x + counter, 0 , boat_to_cell_pos.y + counter) - .1
	front_height = noise.get_noise_3d(boat_to_cell_pos.x + facing_dir.x + counter, 0 , boat_to_cell_pos.y + counter) - .2
	back_height = noise.get_noise_3d(boat_to_cell_pos.x - facing_dir.x + counter, 0 , boat_to_cell_pos.y + counter) - .2
	left_height = noise.get_noise_3d(boat_to_cell_pos.x + counter, 0 , boat_to_cell_pos.x + facing_dir.z + counter) - .2
	right_height = noise.get_noise_3d(boat_to_cell_pos.x + counter, 0 , boat_to_cell_pos.x - facing_dir.z + counter) - .2
	
	var front_back = back_height - front_height
	var left_right = left_height - right_height
	# Adjust boat height + rotation according to surrounding water (/noise)
	position.y = lerp(position.y, boat_height, 0.05)
	mesh.rotation = lerp(mesh.rotation, Vector3(front_back * 2, 0, left_right * 2), 0.05)
