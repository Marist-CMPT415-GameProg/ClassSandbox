class_name FoxState

var walk_speed:float = 2
var run_speed:float = 4

var rng = RandomNumberGenerator.new()

func _init():
	pass

func update(delta:float, body:CharacterBody3D):
	pass

func debug():
	print("FoxState")

func detect_predator():
	pass

func detect_prey():
	pass

