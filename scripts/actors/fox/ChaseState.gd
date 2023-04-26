class_name ChaseState
extends FoxState


func update(delta:float, body:CharacterBody3D):
	pass

func debug():
	print("Chase")

func enter(animation):
	animation.play("Run")
