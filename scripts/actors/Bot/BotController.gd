class_name BotController
extends Node3D

@export var moveSpeed:float
var velocity = Vector3()
@export var health:float
@export var healthRate:float
@export var detectDistance:float
@export var projectile:Node3D #TODO: make this our own class
@onready var animPlayer = get_node("AnimationPlayer")
@onready var audioPlayer = get_node("AudioStreamPlayer3D")

func _physics_process(delta):
	_input(InputEvent)
	
func _input(InputEvent):
	if Input.is_action_pressed("move_right"):
		print("moving right")
	elif Input.is_action_pressed("move_left"):
		print("moving left")
	elif Input.is_action_pressed("move_backward"):
		print("moving backwards")
	elif Input.is_action_pressed("move_forward"):
		print("moving forward")
	else:
		velocity.x = 0
		velocity.z = 0
		print("not moving")
