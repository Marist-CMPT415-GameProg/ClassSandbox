class_name ChaseState
extends FoxState

var CAPTURE_DISTANCE = 1.5

func update(delta:float, body:CharacterBody3D):
	if not predators.is_empty():
		return FleeState.new()
	elif prey.is_empty():
		return WanderState.new()

	# follow the first prey
	var preyPosition:Vector3 = prey[0].global_position
	
	var direction:Vector3 = preyPosition - body.global_position
	
	# if the fox is close enough, capture and destroy the object
	if direction.length() < CAPTURE_DISTANCE:
		#prey[0].queue_free()
		prey.remove_at(0)
		print("captured")
		return IdleState.new()
	# otherwise, run towards the object
	else:
		body.look_at(direction + body.position, Vector3.UP)
		body.velocity = direction.normalized() * run_speed
		body.velocity.y = 0
		body.move_and_slide()
	
	return null

func debug():
	print("Chase")

func enter(animation):
	animation.play("Run")
