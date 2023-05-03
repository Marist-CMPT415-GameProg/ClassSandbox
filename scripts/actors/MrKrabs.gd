extends CharacterBody3D

var speed:float
var vel:Vector3
var state_machine
enum states {IDLE, WALKING, TURNING, DYING}
var current_state = states.IDLE

@onready var animaton_tree = $scene/AnimationTree

func _ready():
	randomize()
	state_machine = animaton_tree.get("parameters/playback")
	speed = 0

func change_state(state):
	match state:
		states.IDLE:
			speed = 0
		states.WALKING:
			speed = 1.5
		#state_machine.travel("Take 001")
	current_state = state

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"state" : current_state
	}
	return save_dict

func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)


func load_data(data):
	position = Vector3(data["pos.x"], data["pos.y"], data["pos.z"])



func _physics_process(delta):
	var target = $NavigationAgent3D.get_next_path_position()
	var pos = get_global_transform().origin
	
	var n = $RayCast3D.get_collision_normal()
	if n.length_squared() < .001:
		n = Vector3(0, 1, 0)
		vel = (target - pos).slide(n).normalized() * speed
		$".".rotation.y = lerp_angle($".".rotation.y, atan2(vel.x, vel.z), delta * 10)
		
		$NavigationAgent3D.set_velocity(vel)
		move_and_slide()
		
func move_to_target(target_pos):
	change_state(states.WALKING)
	var closest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	$NavigationAgent3D.set_target_position(closest_pos)

func get_random_pos(radius:float) -> Vector3:
	var x1 = randi_range(-1,1)
	var x2 = randi_range(-1,1)

	while x1 * x2 + x2 * x2 >= 1:
		x1 = randi_range(-1,1)
		x2 = randi_range(-1,1)
	
	var random_pos = Vector3(0 - 1 * (x1 * x1 + x2 * x2), 0, 0 - 1 * (x1 * x1 + x2 * x2))
	
	random_pos.x *= randi_range(-radius, radius)
	random_pos.z *= randi_range(-radius, radius)
	
	return random_pos

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_velocity(safe_velocity)

func _on_navigation_agent_3d_navigation_finished():
	change_state(states.IDLE)
	$MoveTimer.start()

func _on_move_timer_timeout():
	var sphere_point = get_random_pos(50)
	move_to_target(sphere_point)
