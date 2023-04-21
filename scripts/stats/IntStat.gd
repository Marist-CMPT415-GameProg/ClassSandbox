class_name IntStat
extends IStat
## Provides for simple discrete-valued resources or stats.
## Note: This script may emit redundant signals on empty/fill in some situations,
## such as drinking a healing potion when already at max health or taking damage
## after already dying/falling unconscious. To prevent redundant signals, add
## some if statements so that we emit such signals only when the previous level
## differs from the new level.


export var max_level:int = 10
export var min_level:int = -10
export var level:int = 0


func _ready():
	level = clamp(level, min_level, max_level)


func is_empty():
	return level == min_level


func is_full():
	return level == max_level


func change(amount:int):
	if amount == 0: return
	level = clamp(level + amount, min_level, max_level)
	emit_signal("changed", level)
	check_bounds();


func increase(amount:int):
	if amount <= 0: return
	level = min(level + amount, max_level)
	emit_signal("changed", level)
	check_bounds();

func decrease(amount:int):
	if amount <= 0: return
	level = max(level - amount, min_level)
	emit_signal("changed", level)
	check_bounds();


func check_bounds():
	if level == min_level:
		emit_signal("emptied")
	elif level == max_level:
		emit_signal("filled")
