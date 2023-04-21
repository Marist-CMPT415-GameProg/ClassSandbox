class_name FloatResource
extends Node


signal changed(value) # value is an float
signal emptied
signal filled


export var max_level:float = 100
export var min_level:float = 0
export var level:float = 100


func change(amount:float):
	if amount != 0:
		level = clamp(level + amount, min_level, max_level)
		emit_signal("changed", level)
		if level == max_level:
			emit_signal("filled")
		elif level == min_level:
			emit_signal("emptied")


func increase(amount:float):
	if amount > 0:
		level = min(level + amount, max_level)
		emit_signal("changed", level)
		if level == max_level:
			emit_signal("filled")


func decrease(amount:float):
	if amount > 0:
		level = max(level - amount, min_level)
		emit_signal("changed", level)
		if level == min_level:
			emit_signal("emptied")
