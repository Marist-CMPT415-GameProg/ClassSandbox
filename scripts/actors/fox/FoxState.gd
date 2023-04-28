class_name FoxState

var walk_speed:float = 2
var run_speed:float = 4

var rng = RandomNumberGenerator.new()

var predators = []
var prey = []

func _init():
	pass

func enter(animation):
	pass

func exit(animation):
	animation.stop()

func update(delta:float, body:CharacterBody3D):
	pass

func debug():
	print("FoxState")
