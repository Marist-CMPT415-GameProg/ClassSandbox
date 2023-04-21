extends CharacterBody3D


var current_state:FoxState

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = IdleState.new(1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_state:FoxState = current_state.update()
	
	if new_state != null:
		current_state = new_state
