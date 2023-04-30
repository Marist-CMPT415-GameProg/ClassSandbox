extends CharacterBody3D

enum States { IDLE, WANDER, CHASE, FLEE }

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
	
	#current_state.debug()

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

func save_data():
	var current_state_enum
	
	if current_state is IdleState:
		current_state_enum = States.IDLE
	elif current_state is WanderState:
		current_state_enum = States.WANDER
	elif current_state is FleeState:
		current_state_enum = States.FLEE
	elif current_state is ChaseState:
		current_state_enum = States.CHASE
	
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"pos_z" : position.z,
		"state" : current_state_enum
	}
	return save_dict

func load_data(node_data):
	position = Vector3(node_data["pos_x"], node_data["pos_y"], node_data["pos_z"])
	
	var current_state_enum = node_data["state"]
	
	if current_state_enum == States.IDLE:
		current_state = IdleState.new()
	if current_state_enum == States.WANDER:
		current_state = WanderState.new()
	if current_state_enum == States.CHASE:
		current_state = ChaseState.new()
	if current_state_enum == States.FLEE:
		current_state = FleeState.new()
