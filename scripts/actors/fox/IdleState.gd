class_name IdleState
extends FoxState

const timeUntilWander:float = 2
var currentTime:float

func _init():
	currentTime = timeUntilWander

func update(delta:float, body:CharacterBody3D):
	if not predators.is_empty():
		return FleeState.new()
	elif not prey.is_empty():
		return ChaseState.new()
	
	currentTime -= delta
	
	if (currentTime <= 0):
		return WanderState.new()
	
	return null

func debug():
	print("Idle")
	
func enter(animation):
	animation.play("Survey")
