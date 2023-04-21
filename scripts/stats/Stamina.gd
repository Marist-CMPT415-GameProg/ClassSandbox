class_name Stamina
extends IntResource

## Provides a simple stamina stat for use with character entities.
##
## Uses an integer representation and discrete increment/decrement.

## Amount to refill per second.
@export var fill_rate:int = 1
## Amount to drain per second when exerting.
@export var drain_rate:int = 1

## Numbers of seconds to replenish one unit (computed from fill/drain rates)
var secs_per_unit:float
## Number of seconds remaining before the next fill/drain increment
var timeout:float
## Indicates whether stamina is idle (replenishing) or exerting (draining).
var is_draining:bool


func _init():
	secs_per_unit = 1.0 / fill_rate
	timeout = secs_per_unit


func _process(delta):
	if is_draining:
		if is_empty():
			return
	elif is_full():
		return

	timeout -= delta
	if timeout <= 0:
		timeout = secs_per_unit
		if is_draining:
			decrease(1)
		else:
			increase(1)


## Used to change between fill and drain modes in response to signals
func on_drain(drain:bool):
	is_draining = drain
	if is_draining:
		secs_per_unit = 1.0 / drain_rate
	else:
		secs_per_unit = 1.0 / fill_rate
	timeout = secs_per_unit
