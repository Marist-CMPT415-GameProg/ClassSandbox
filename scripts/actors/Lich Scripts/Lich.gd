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
		idle(delta)
	elif stateNum == 1:
		patrol(delta)
	elif stateNum == 2:
		chase(delta)
	elif stateNum == 3:
		attack()
		
	pass


func idle(delta):
	$"Lich Model/AnimationPlayer".play("Armature|Idle")
	if idlePos != position:
		idlePos = position
	if idleTime <= 0:
		stateNum = 1
		idleTime = 2
	idleTime -= delta
	pass
	
func patrol(delta):
	$"Lich Model/AnimationPlayer".play("Armature|Walk")
	if idlePos.z + patDistance <= position.z:
		stateNum = 0
	velocity.z -= walkSpeed * delta
	move_and_slide()
	pass

func chase(delta):
	$"Lich Model/AnimationPlayer".play("Armature|Run")
	pass
	
func attack():
	$"Lich Model/AnimationPlayer".play("Armature|Jump")
	stateNum = 3
	pass






