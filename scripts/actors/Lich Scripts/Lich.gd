class_name Lich
extends CharacterBody3D

@export var patDistance = 10
@export var idleTime = 2
@export var walkSpeed = 3
@export var runSpeed = 7

var stateNum = 1;
var stateReady:bool = true
var idlePos


# Called when the node enters the scene tree for the first time.
func _ready():
	idlePos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stateNum == 0:
		idle()
	elif stateNum == 1:
		patrol()
	elif stateNum == 2:
		chase()
	elif stateNum == 3:
		attack()
		
	pass


func idle():
	$"Lich Model/AnimationPlayer".play("Armature|Idle")
	if idlePos != position:
		idlePos = position
	stateNum = 1
	pass
	
func patrol():
	$"Lich Model/AnimationPlayer".play("Armature|Walk")
	translate(Vector3.FORWARD)
	pass

func chase():
	$"Lich Model/AnimationPlayer".play("Armature|Run")
	pass
	
func attack():
	$"Lich Model/AnimationPlayer".play("Armature|Jump")
	stateNum = 3
	pass






