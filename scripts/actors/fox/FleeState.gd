class_name FleeState
extends FoxState


func update(delta:float, body:CharacterBody3D):
	pass

func debug():
	print("Flee")

func enter(animation):
	animation.play("Run")
