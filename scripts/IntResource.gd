class_name IntResource
extends Node


signal changed(value) # value is an int
signal emptied
signal filled


export var max_level:int = 100
export var min_level:int = 0
export var level:int = 100


func _ready():
	level = clamp(level, min_level, max_level)


func is_empty():
	return level == min_level


func is_full():
	return level == max_level


func change(amount:int):
	if amount != 0:
		level = clamp(level + amount, min_level, max_level)
		emit_signal("changed", level)
		if level == max_level:
			emit_signal("filled")
		elif level == min_level:
			emit_signal("emptied")


func increase(amount:int):
	if amount > 0:
		level = min(level + amount, max_level)
		emit_signal("changed", level)
		if level == max_level:
			emit_signal("filled")


func decrease(amount:int):
	if amount > 0:
		level = max(level - amount, min_level)
		emit_signal("changed", level)
		if level == min_level:
			emit_signal("emptied")
