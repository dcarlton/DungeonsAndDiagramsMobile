class_name PathButton
extends Node2D

static var empty_path_texture = load("res://sprites/EmptyPath.png")
static var unknown_path_texture = load("res://sprites/UnknownPath.png")
static var wall_texture = load("res://sprites/Wall.png")

signal pressed
signal released
var state: PathState.State:
	get:
		return state
	set(value):
		state = value
		match value:
			PathState.State.EMPTY:
				$TouchScreenButton.texture_normal = empty_path_texture
				
			PathState.State.UNKNOWN:
				$TouchScreenButton.texture_normal = unknown_path_texture
				
			PathState.State.WALL:
				$TouchScreenButton.texture_normal = wall_texture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = PathState.State.WALL


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	event

func _on_touch_screen_button_pressed() -> void:
	pressed.emit(state, func(new_state: PathState.State): state = new_state)


func _on_touch_screen_button_released() -> void:
	released.emit()
