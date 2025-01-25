extends Camera3D

@onready var head = $".."
@export var sensitivity = 0.01
@onready var player = $"../../../../../CharacterBody3D"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#self.global_position.x = player.global_position.x
	#self.global_position.y = player.global_position.y
	#self.global_position.z = player.global_position.z
	pass
