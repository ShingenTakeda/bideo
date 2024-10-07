extends Node

var states: Dictionary = {}
var current_state : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child

func _process(delta: float):
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
		
func on_child_transition(state, new_state_name):
	if state != new_state_name:
		return

	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return

	if current_state:
		current_state.exit()

	new_state.enter()

	current_state = new_state