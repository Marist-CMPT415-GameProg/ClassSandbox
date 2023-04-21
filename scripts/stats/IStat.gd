class_name IStat
extends Node

signal on_changed(level)
signal on_emptied
signal on_filled

func _ready(): pass

func is_empty(): pass
func is_full(): pass

func change(amount): pass
func increase(amount): pass
func decrease(amount): pass

func check_bounds(): pass
