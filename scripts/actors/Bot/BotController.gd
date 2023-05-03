class_name BotController
extends CharacterBody3D

@export var moveSpeed:float
@export var currentHealth:float
@export var maxHealth:float
@export var healingRate:float
@export var detectDistance:float
@export var ammo:float
@export var projectile:Node3D #TODO: Make this our own class.
@onready var animPlayer = get_node("AnimationPlayer")
@onready var audioPlayer = get_node("AudioStreamPlayer3D")
var direction:Vector3
var player

func _ready():
	player = get_node("../Player")
	print("Bot ready: ", player)

func _process(delta):
	animPlayer.play("walk")
	#TODO: Move/rotate towards the player every frame.
	if player == null:
		print("Where is Player?")
	position = position.move_toward(player.position, moveSpeed * delta)

func save_data():
	var save_dict = {
#		"filename" : get_scene_file_path(),
#		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"pos_z" : position.z,
#		"rotation" : rotation,
		"current_health" : currentHealth,
		"max_health" : maxHealth,
		"healing_rate" : healingRate,
		"ammo" : ammo,
		"move_speed" : moveSpeed,
		"detect_distance" : detectDistance
	}
	return save_dict

func load_data(data):
#	var new_object = load(data["filename"]).instantiate()
#	get_node(data["parent"]).add_child(new_object)
	position = Vector3(data["pos_x"], data["pos_y"], data["pos_z"])
#	rotation = data["rotation"]
	currentHealth = data["current_health"]
	maxHealth = data["max_health"]
	healingRate = data["healing_rate"]
	ammo = data["ammo"]
	moveSpeed = data["move_speed"]
	detectDistance = data["detect_distance"]
	print("Bot loaded: ", player)
