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
		"idle":
			current_state = states.IDLE
			speed = .000001
		"walking":
			current_state = states.WALKING
			speed = 1.5

func _physics_process(delta):
	var target = $NavigationAgent3D.get_next_location()
	var pos = get_global_transform().origin
	
	var n = $RayCast3D.get_collision_normal()
	if n.length_squared() < .001:
		n = Vector3(0, 1, 0)
		vel = (target - pos).slide(n).normalized() * speed
		$Krabs.rotation.y = lerp_angle($Krabs.rotation.y, atan2(vel.x, vel.z), delta * 10)
		
		$NavigationAgent3D.set_velocity(vel)
		move_and_slide()
		
func move_to_target(target_pos):
	change_state("walking")
	var closest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	$NavigationAgent3D.set_target_location(closest_pos)

func get_random_pos(radius:float) -> Vector3:
	var x1 = randi_range(-1,1)
	var x2 = randi_range(-1,1)
	
	while x1 * x2 + x2 * x2 >= 1:
		 x1 = randi_range(-1,1)
		 x2 = randi_range(-1,1)
