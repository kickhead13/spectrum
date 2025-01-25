extends CharacterBody3D

const SPEED = 8
const JUMP_VELOCITY = 4
@export var sensitivity = 0.01
@onready var player_head = $".."
@onready var camera_bob_time = 0
@export var bob_freq = 2
@export var bob_amp = 0.04
@onready var cameras = [
	$"../GridContainer/SubViewportContainer/SubViewport/Node3D/Camera3D",
	$"../GridContainer/SubViewportContainer2/SubViewport/Node3D/Camera3D",
	$"../GridContainer2/SubViewportContainer/SubViewport/Node3D/Camera3D",
	$"../GridContainer2/SubViewportContainer2/SubViewport/Node3D/Camera3D"
]
var camera = 0

@onready var heads = [
	$"../GridContainer/SubViewportContainer/SubViewport/Node3D",
	$"../GridContainer/SubViewportContainer2/SubViewport/Node3D",
	$"../GridContainer2/SubViewportContainer/SubViewport/Node3D",
	$"../GridContainer2/SubViewportContainer2/SubViewport/Node3D"
]
var head = 0

func _headbob(cbt) -> Vector3:
	var temp = Vector3.ZERO
	temp.y = sin(cbt * bob_freq) * bob_amp
	temp.x = cos(cbt * bob_freq / 2) * bob_amp
	print(temp)
	return temp

func _unhandled_input(event: InputEvent) -> void:
	# handle mouse movement (working)
	# -- the head of cameras are needed to solve some problems relating to mouse movement link to docs:
	#    https://docs.godotengine.org/en/4.0/tutorials/3d/using_transforms.html
	if event is InputEventMouseMotion:
		heads[head].rotate_y(-event.relative.x * sensitivity)
		cameras[camera].rotate_x(-event.relative.y * sensitivity)
		cameras[camera].rotation.x = clamp(cameras[camera].rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
		# main movement loop (working)
	# -- looks at the transform basis vector of the current camera's head to determine the direction of
	#    the camera, this is so the movement isn't cartasian blocked
	# -- the else condition is for friction, so that the character doesn't just stop instantly
	var input_dir := Input.get_vector("mov_left", "mov_right", "mov_up", "mov_down")
	var direction = (heads[head].transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if velocity.x != 0:
			velocity.x += -1 * (velocity.x/100) * SPEED
		if velocity.z != 0:
			velocity.z += -1 * (velocity.z/100) * SPEED
	
	#gravity and jumping (working)
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# sliding (working)
	if Input.is_action_just_pressed("mov_shift"):
		direction = (heads[head].transform.basis * Vector3(0, 0, -100)).normalized()
		velocity.x = direction.x * SPEED * SPEED
		velocity.z = direction.z * SPEED * SPEED
	
	# toggling between cameras (working)
	var vp_input = ["num_1","num_2","num_3","num_4"]
	var count = 0
	for input in vp_input:
		if Input.is_action_just_pressed(input):
			camera = count
			head = count
		count += 1
	
	# keeping head on player (working)
	for head_in in heads:
		head_in.global_position.x = self.global_position.x
		head_in.global_position.y = self.global_position.y
		head_in.global_position.z = self.global_position.z
	
	# view bobbing (not working)
	camera_bob_time += delta * self.velocity.length() * float(is_on_floor())
	for camera_ in cameras: 
		camera_.transform.origin = _headbob(camera_bob_time)
	
	move_and_slide()
