extends CharacterBody3D

const SPEED = 12
const JUMP_VELOCITY = 4
@export var sensitivity = 0.01
@onready var player_head = $".."
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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		heads[head].rotate_y(-event.relative.x * sensitivity)
		cameras[camera].rotate_x(-event.relative.y * sensitivity)
		cameras[camera].rotation.x = clamp(cameras[camera].rotation.x, deg_to_rad(-40), deg_to_rad(60))
		self.rotate_x(-event.relative.y * sensitivity)
		self.rotation.x = clamp(self.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("mov_shift"):
		velocity.z = -1*SPEED*SPEED
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("mov_left", "mov_right", "mov_up", "mov_down")
	var direction = (heads[head].transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		print(self.position)
	else:
		if velocity.x != 0:
			velocity.x += -1 * (velocity.x/100) * SPEED
		if velocity.z != 0:
			velocity.z += -1 * (velocity.z/100) * SPEED
	
	var vp_input = ["num_1","num_2","num_3","num_4"]
	var count = 0
	for input in vp_input:
		if Input.is_action_just_pressed(input):
			camera = count
			head = count
		count += 1
	
	for head_in in heads:
		head_in.global_position.x = self.global_position.x
		head_in.global_position.y = self.global_position.y
		head_in.global_position.z = self.global_position.z
		print(head_in.position, self.position)
	
	move_and_slide()
"""
	var vp_size = viewports[viewport].size
	var vp_mouse_pos = viewports[viewport].get_mouse_position()
	# 2print(vp_mouse_pos)
	
	if vp_mouse_pos[0] > vp_size[0] - 4:
		vp_mouse_pos[0] = 4
	if vp_mouse_pos[0] < 4:
		vp_mouse_pos[0] = vp_size[0] - 4
	if vp_mouse_pos[1] > vp_size[1] - 4:
		vp_mouse_pos[1] = 4
	if vp_mouse_pos[1] < 4:
		vp_mouse_pos[1] = vp_size[1] - 4
	viewports[viewport].warp_mouse(vp_mouse_pos)
"""
