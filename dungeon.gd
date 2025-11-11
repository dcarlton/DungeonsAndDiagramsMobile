extends GridContainer

@export var pathButton: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, 64):
		add_child(PathButton())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
