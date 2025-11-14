extends GridContainer

enum DraggingPathState {EMPTY_TO_UNKNOWN, EMPTY_TO_WALL, NULL, UNKNOWN_TO_EMPTY, UNKNOWN_TO_WALL, WALL_TO_EMPTY, WALL_TO_UNKNOWN}

@export var pathButton: PackedScene
var dragging_path_state = null # Type is PathScene.Scene | null, but GDScript doesn't have a nullable type
var num_pressed_buttons = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in get_tree().get_nodes_in_group("PathButtons"):
		button.pressed.connect(_on_button_pressed)
		button.released.connect(_on_button_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed(state: PathState.State, set_state: Callable, double_tapped: bool):
	$EndDraggingTimer.stop()
	num_pressed_buttons += 1
	match state:
		PathState.State.EMPTY:
			match dragging_path_state:
				DraggingPathState.NULL, DraggingPathState.EMPTY_TO_UNKNOWN:
					set_state.call(PathState.State.UNKNOWN)
					dragging_path_state = DraggingPathState.EMPTY_TO_UNKNOWN
				DraggingPathState.EMPTY_TO_WALL:
					set_state.call(PathState.State.WALL)
				DraggingPathState.WALL_TO_EMPTY:
					# Double tapped
					set_state.call(PathState.State.UNKNOWN)
					dragging_path_state = DraggingPathState.WALL_TO_UNKNOWN
		PathState.State.UNKNOWN:
			match dragging_path_state:
				DraggingPathState.NULL, DraggingPathState.UNKNOWN_TO_WALL:
					set_state.call(PathState.State.WALL)
					dragging_path_state = DraggingPathState.UNKNOWN_TO_WALL
				DraggingPathState.UNKNOWN_TO_EMPTY:
					set_state.call(PathState.State.EMPTY)
				DraggingPathState.EMPTY_TO_UNKNOWN:
					# Double tapped
					set_state.call(PathState.State.WALL)
					dragging_path_state = DraggingPathState.EMPTY_TO_WALL
		PathState.State.WALL:
			match dragging_path_state:
				DraggingPathState.NULL, DraggingPathState.WALL_TO_EMPTY:
					set_state.call(PathState.State.EMPTY)
					dragging_path_state = DraggingPathState.WALL_TO_EMPTY
				DraggingPathState.WALL_TO_UNKNOWN:
					set_state.call(PathState.State.UNKNOWN)
				DraggingPathState.UNKNOWN_TO_WALL:
					# Double tapped
					set_state.call(PathState.State.EMPTY)
					dragging_path_state = DraggingPathState.UNKNOWN_TO_EMPTY
	

func _on_button_released():
	num_pressed_buttons -= 1
	if num_pressed_buttons == 0:
		$EndDraggingTimer.start()


func _on_end_dragging_timer_timeout() -> void:
	dragging_path_state = DraggingPathState.NULL
