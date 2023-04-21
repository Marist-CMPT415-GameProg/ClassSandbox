extends Node

signal do_move(dir)
signal do_sprint
signal do_jump
signal do_crouch(crouching)

export var receiver:NodePath

func _ready():
	var node = get_node(receiver)
	connect("do_move", node, "on_move")
	connect("do_jump", node, "on_jump")
	connect("do_crouch", node, "on_crouch")
	connect("do_sprint", node, "on_sprint")


func _input(event):
	if event.is_action("move"):
		emit_signal("do_move", Input.get_vector("move_left", "move_right", "move_forward", "move_backward"))

	if event.is_action_pressed("jump"):
		print("jump")
		emit_signal("do_jump")

	if event.is_action("crouch") and not event.is_echo():
		emit_signal("do_crouch", event.is_pressed())

	if event.is_action("sprint") and not event.is_echo():
		emit_signal("do_sprint", event.is_pressed())

