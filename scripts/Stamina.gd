class_name Stamina
extends "res://scripts/IntResource.gd"

export var fill_rate:int = 1 # amount to refill per second, in 1 sec we fill 1/fill_rate
export var drain_rate:int = 1 # amount to drain per second

var secs_per_unit:float
var timeout:float

var is_draining:bool

func _ready():
	secs_per_unit = 1.0 / fill_rate
	timeout = secs_per_unit

func _process(delta):
	if is_draining:
		if is_empty(): return
	elif is_full(): return

	timeout -= delta
	if timeout <= 0:
		timeout = secs_per_unit
		if is_draining:
			decrease(1)
		else:
			increase(1)

func on_drain(drain:bool):
	is_draining = drain
	print(drain)
	if is_draining:
		secs_per_unit = 1.0 / drain_rate
	else:
		secs_per_unit = 1.0 / fill_rate
	timeout = secs_per_unit
