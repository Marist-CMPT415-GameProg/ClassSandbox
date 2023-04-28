class_name FloatResource
extends Node

## Provides for simple continuous (real-valued) resources or stats.
##
## Note that this script may emit redundant signals on empty/fill in some
## situations, such as drinking a healing potion when already at max health or
## taking damage after already dying/falling unconscious. To prevent redundant
## signals, add some if statements so that we emit such signals only when the
## previous level differs from the new level.


## Notifies listeners of the new level when this resource changes
signal changed(float)
## Notifies listeners when this resource reaches its minimum level
signal emptied
## Notifies listeners when this resource reaches its maximum level
signal filled

## Upper limit for this stat/resource.
@export var max_level:float = 100
## Lower limit for this stat/resource.
@export var min_level:float = 0
## Current/starting value for this stat/resource.
@export var level:float = 100


func _init():
	level = clamp(level, min_level, max_level)
	changed.emit(level)


## Indicates whether this resources is at its [member min_level]
func is_empty():
	return level == min_level


## Indicates whether this resources is at its [member max_level]
func is_full():
	return level == max_level


## Change the current level by a non-zero amount and notify registered listeners
func change(amount:float):
	if amount == 0:
		return
	level = clamp(level + amount, min_level, max_level)
	emit_signal("changed", level)
	check_bounds();


## Increment the level of this resource by some amount and notify any listeners
func increase(amount:float):
	if amount <= 0:
		return
	level = min(level + amount, max_level)
	emit_signal("changed", level)
	if level == max_level:
		emit_signal("filled")


## Decrement the level of this resource by some amount and notify any listeners
func decrease(amount:float):
	if amount <= 0:
		return
	level = max(level - amount, min_level)
	emit_signal("changed", level)
	if level == min_level:
		emit_signal("emptied")


## Used to notify listeners when this resource reaches its minimum or maximum
func check_bounds():
	if level == min_level:
		emit_signal("emptied")
	elif level == max_level:
		emit_signal("filled")
