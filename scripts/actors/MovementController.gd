class_name MovementController
extends Node

## Provides for input-based control over a character physics body.
##
## Handles "move", "sprint", "crouch", and "jump" input actions. Note that
## thsi implementation disallows sprint while crouching.
##
## For the purpose of demonstration, this version uses signals to notify the
## character body upon receipt of certain input actions. This allows for a
## separation of input processing from game mechanics, at the cost of some
## overhead for signal transmission. An more efficient alternative might be
## to directly call methods on the character body script; if you pursue this
## approach, be sure to check that the controller body provides the necessary
## interface by using GDScript's [code]hasMethod[/code] (a substitute
## for interface mechanisms provided by other coding languages).


## Notifies listeners of a change to the direction of motion
signal moved(Vector3)
## Notifies listeners of a change in orientation
signal turned(float)
## Notifies listeners when switching between walk and run
signal sprinted(bool)
## Notifies a character upon entering or exiting a crouch
signal crouched(bool)
## Notifies a character when a jump action is initiated
signal jumped()

## Notifies listeners of a change to the camera orientation
@export var controlled_body:NodePath
## Notifies listeners of a change to the camera orientation
@export var is_sprint_toggle:bool = false
## Notifies listeners of a change to the camera orientation
@export var is_crouch_toggle:bool = false

## Indicates whether the camera provides a 1st-person or 3rd-person view
var is_camera_first_person:bool = false
## Normalized direction of motion in the XZ-plane
var move_dir:Vector3 = Vector3.ZERO
## Yaw angle of the camera in global coordinates
var camera_angle:float = 0
## Indicates whether the character is sprinting
var is_sprint_on:bool = false
## Indicates whether the character is crouching
var is_crouch_on:bool = false


# TODO Reduce coupling in the code by setting connecting signals in the editor's Node tab instead
func _ready():
	var receiver = get_node(controlled_body)
	connect("moved", receiver.on_move)
	connect("turned", receiver.on_turn)
	connect("sprinted", receiver.on_sprint)
	connect("crouched", receiver.on_crouch)
	connect("jumped", receiver.on_jump)
	print("Player ready: ", self)


func _input(event):
	if event.is_action("move") and not event.is_echo():
		var input_dir = Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
		move_dir = Vector3(-input_dir.x, 0, -input_dir.y)
		turn_and_go(not input_dir.is_equal_approx(Vector2.ZERO))

	if event.is_action_pressed("jump"):
		emit_signal("jumped")

	if event.is_action("crouch") and not event.is_echo():
		on_crouch(event.is_pressed())

	if event.is_action("sprint") and not event.is_echo():
		on_sprint(event.is_pressed())


## Control the orientation and motion of the character physics body
func turn_and_go(in_motion:bool):
	if is_camera_first_person:
		emit_signal("turned", camera_angle)
	elif in_motion:
		emit_signal("turned", camera_angle + atan2(-move_dir.x, -move_dir.z))
	emit_signal("moved", move_dir.rotated(Vector3.UP, camera_angle) if in_motion else Vector3.ZERO)


## Handles the "crouch" input action
func on_crouch(is_pressed:bool):
	if is_crouch_toggle:
		if is_pressed:
			is_crouch_on = not is_crouch_on
			emit_signal("crouched", is_crouch_on)
			if is_crouch_on:
				is_sprint_on = false
	else:
		is_crouch_on = is_pressed
		emit_signal("crouched", is_crouch_on)
		if is_crouch_on:
			is_sprint_on = false


## Handles the "sprint" input action
func on_sprint(is_pressed:bool):
	if is_crouch_on:
		return
	if is_sprint_toggle:
		if is_pressed:
			is_sprint_on = not is_sprint_on
			emit_signal("sprinted", is_sprint_on)
	else:
		is_sprint_on = is_pressed
		emit_signal("sprinted", is_sprint_on)


## Ensures that the character faces the direction of motion even if the view changes
func on_look(angle:float):
	camera_angle = angle
	turn_and_go(not move_dir.is_equal_approx(Vector3.ZERO))


## Faciliates adjusting the movement mechanics based on the camera viewpoint
func on_view_changed(is_first_person:bool):
	is_camera_first_person = is_first_person


func save_data():
	var saved_data = {
		"health": $CharacterStats/Health.max_level,
		"stamina": $CharacterStats/Stamina.max_level,
		"stamina_fill": $CharacterStats/Stamina.fill_rate,
		"stamina_drain": $CharacterStats/Stamina.drain_rate,
		"xpos": $Character.position.x,
		"ypos": $Character.position.y,
		"zpos": $Character.position.z,
		"walk_speed": $Character.walk_speed,
		"run_speed": $Character.run_speed,
		"turn_speed": $Character.turn_speed,
		"crouch_speed": $Character.crouch_speed,
		"crouch_height": $Character.crouch_height,
		"jump_height": $Character.jump_height,
		"acceleration": $Character.acceleration
	}
	return saved_data

func load_data(data):
	$CharacterStats/Health.max_level = data["health"]
	$CharacterStats/Stamina.max_level = data["stamina"]
	$CharacterStats/Stamina.fill_rate = data["stamina_fill"]
	$CharacterStats/Stamina.drain_rate = data["stamina_drain"]
	$Character.position = Vector3(data["xpos"], data["zpos"], data["zpos"])
	$Character.walk_speed = data["walk_speed"]
	$Character.run_speed = data["run_speed"]
	$Character.turn_speed = data["turn_speed"]
	$Character.crouch_speed = data["crouch_speed"]
	$Character.crouch_height = data["crouch_height"]
	$Character.jump_height = data["jump_height"]
	$Character.acceleration = data["acceleration"]
	print("Player loaded: ", self)

