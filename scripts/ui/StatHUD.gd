extends Control

## Use to update a basic flat HUD for character stats.
##
## Requires that the stats HUD node contains [code]ColorRect[/code] children
## named "HealthBar" and "StaminaBar" for displaying the corresponding stats.
## Also assumes a maximum level of 100 for both stats. One way to make this
## more flexible/configurable is to have the stat scripts include the maximum
## and/or minimum levels in the relevant "changed" signals.


## Color of the health bar
@export var health_color:Color = Color.RED
## Color of the stamina bar
@export var stamina_color:Color = Color.GREEN
## Height of the bars
@export var bar_height:float = 20
## Width of the bars when full
@export var bar_width:float = 180


func _ready():
	$HealthBar.color = health_color
	$StaminaBar.color = stamina_color


## Note: You must add an additional argument to the changed signal
## so that this script knows which UI stat bar to update
func on_stat_changed(level:int, stat_bar_name:String):
	get_node(stat_bar_name).set_size(Vector2(level * bar_width / 100, bar_height))

func on_health_changed(level:int):
	$HealthBar.set_size(Vector2(level * bar_width / 100, bar_height))

func on_stamina_changed(level:int):
	print("new stamina ", level)
	$StaminaBar.set_size(Vector2(level * bar_width / 100, bar_height))
