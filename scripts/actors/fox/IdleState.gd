class_name IdleState
extends FoxState

const timeUntilWander:float = 5
var currentTime:float

func _init():
	currentTime = timeUntilWander

func update(delta:float, body:CharacterBody3D, model:Node3D):
	currentTime -= delta
	
	if (currentTime <= 0):
		return WanderState.new()
	
	return null

func debug():
	print("Idle")
