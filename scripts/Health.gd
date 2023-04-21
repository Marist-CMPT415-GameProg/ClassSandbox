class_name Health
extends "res://scripts/IntResource.gd"


func _input(event):
	if event.is_action_pressed("heal"):
		increase(10)
	if event.is_action_pressed("harm"):
		decrease(15)
