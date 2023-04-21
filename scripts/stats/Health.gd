class_name Health
extends IntResource

## Provides a simple health stat for use with character entities.
##
## Uses an integer representation and discrete increment/decrement.


## For purpose of demonstration only - similar logic should likely be handled
## by some relevant combat and/or item scripts, such as a Weapon/Damage script
## or a Poison/Potion script.
func _input(event):
	if event.is_action_pressed("heal"):
		increase(10)
	if event.is_action_pressed("harm"):
		decrease(15)
