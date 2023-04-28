class_name BotController
extends CharacterBody3D

@export var moveSpeed:float
@export var currentHealth:float
@export var maxHealth:float
@export var healingRate:float
@export var detectDistance:float
@export var ammo:float
@export var projectile:Node3D #TODO: make this our own class
@onready var animPlayer = get_node("AnimationPlayer")
@onready var audioPlayer = get_node("AudioStreamPlayer3D")
var direction:Vector3
var player

func _ready():
	player = get_node("../Player")

func _process(delta):
	animPlayer.play("walk")
	#TODO: move/rotate towards the player every frame
	position = position.move_toward(player.position, moveSpeed * delta)

func save_data():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"pos_z" : position.z,
		"rot" : rotation,
		"current_health" : currentHealth,
		"max_health" : maxHealth,
		"healing_rate" : healingRate,
		"ammo" : ammo,
		"move_speed" : moveSpeed,
		"detect_distance" : detectDistance
	}
	return save_dict
