class_name WanderState
extends FoxState

const timeUntilIdle:float = 15
var currentTime:float

var currentDirectionTime:float
var currentDirection:Vector3

func _init():
	currentTime = timeUntilIdle
	currentDirectionTime = 0

func update(delta:float, body:CharacterBody3D):
	currentTime -= delta
	currentDirectionTime -= delta
	
	if currentDirectionTime <= 0:
		currentDirectionTime = rng.randf_range(3, 6)
		currentDirection.x = rng.randf_range(-5, 5)
		currentDirection.z = rng.randf_range(-5, 5)
		body.look_at(currentDirection + body.position, Vector3.UP)
	
	body.velocity = currentDirection.normalized() * walk_speed
	body.move_and_slide()
	
	if (currentTime <= 0):
		return IdleState.new()
	
	return null

func debug():
	print("Wander")
