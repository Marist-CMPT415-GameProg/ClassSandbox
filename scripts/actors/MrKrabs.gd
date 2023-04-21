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
	
