class_name Lich
extends CharacterBody3D

@export var patDistance = 10
@export var idleTime = 2
@export var walkSpeed = 3
@export var runSpeed = 15
@export var damage = 10
@export var health = 200

var stateNum = 1
var idlePos:Vector3
var player = Character
var dir

var curr_health = 200
var is_alive:bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	idlePos = position
	dir = -1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stateNum == 0:
		idle(delta)
	elif stateNum == 1:
		patrol()
	elif stateNum == 2:
		chase(delta)
	elif stateNum == 3:
		attack()


func idle(delta):
	$"Lich Model/AnimationPlayer".play("Armature|Idle")
	if idlePos != position:
		idlePos = position
	if idleTime <= 0:
		stateNum = 1
		idleTime = 2
		dir *= -1
	else:
		idleTime -= delta
		rotate(Vector3(0, 1, 0), 1.55*delta)
	pass
	
func patrol():
	$"Lich Model/AnimationPlayer".play("Armature|Walk")		
	if idlePos.z + patDistance <= position.z or idlePos.z - patDistance >= position.z:
		stateNum = 0
	velocity.z = walkSpeed * dir
	move_and_slide()


func chase(delta):
	$"Lich Model/AnimationPlayer".play("Armature|Run")

	
func attack():
	$"Lich Model/AnimationPlayer".play("Armature|Jump")
	stateNum = 3

func save_data():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"pos_z" : position.z,
		"idlePos_x" : idlePos.x,
		"idlePos_y" : idlePos.y,
		"idlePos_z" : idlePos.z,
		"dir" : dir,
		"health" : health,
		"curr_health" : curr_health,
		"damage" : damage,
		"stateNum" : stateNum,
		"is_alive" : is_alive
	}
	return save_dict

func load_data(data):
	position = Vector3(data["pos_x"],data["pos_y"],data["pos_z"])
	idlePos = Vector3(data["idlePos_x"],data["idlePos_y"],data["idlePos_z"])
	
	for prop in data.keys():
		if prop.substr(0,3) == "pos" or prop == "idlePos":
			continue
	


















