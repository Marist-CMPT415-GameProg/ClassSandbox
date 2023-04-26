extends CharacterBody3D


var current_state:FoxState
@export var animation:AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = IdleState.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_state:FoxState = current_state.update(delta, self)
	
	if new_state != null:
		current_state.exit(animation)
		
		# copy over predator and prey data
		new_state.predators = current_state.predators
		new_state.prey = current_state.prey
		
		current_state = new_state
		
		current_state.enter(animation)
	
	current_state.debug()

func predator_entered(body:Node3D):
	if body.is_in_group("predator"):
		current_state.predators.append(body)

func predator_exited(body:Node3D):
	if body.is_in_group("predator"):
		current_state.predators.remove_at(current_state.predators.find(body))

func prey_entered(body:Node3D):
	if body.is_in_group("prey"):
		current_state.prey.append(body)

func prey_exited(body:Node3D):
	if body.is_in_group("prey"):
		current_state.prey.remove_at(current_state.prey.find(body))
