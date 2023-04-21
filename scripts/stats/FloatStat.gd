class_name FloatStat
extends IStat
# NOTE This script may emit redundant signals on empty/fill in some situations,
# such as drinking a healing potion when already at max health or taking damage
# after already dying/falling unconscious. To prevent redundant signals, add
# some if statements so that we emit such signals only when the previous level
# differs from the new level.


export var max_level:float = 100
export var min_level:float = 0
export var level:float = 100


func change(amount:float):
	if amount == 0: return
	level = clamp(level + amount, min_level, max_level)
	emit_signal("changed", level)
	check_bounds();


func increase(amount:float):
	if amount <= 0: return
	level = min(level + amount, max_level)
	emit_signal("changed", level)
	check_bounds();

func decrease(amount:float):
	if amount <= 0: return
	level = max(level - amount, min_level)
	emit_signal("changed", level)
	check_bounds();


func check_bounds():
	if level == min_level:
		emit_signal("emptied")
	elif level == max_level:
		emit_signal("filled")
