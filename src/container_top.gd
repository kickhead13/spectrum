extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.size.x = DisplayServer.window_get_size().x
	self.size.y = DisplayServer.window_get_size().y / 2
