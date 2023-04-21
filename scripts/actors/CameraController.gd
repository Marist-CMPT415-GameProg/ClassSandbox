class_name CameraController
extends Node3D

## Provides input-based control over the player camera view.
##
## For the purpose of demonstration, this version uses signals to notify a
## separate movement controller upon receipt of certain input actions. This
## allows for a modular approach to handling movement and viewpoint, at the
## cost of some overhead for signal transmission. An more efficient alternative
## might be to directly call methods on the movement controller script; if you
## pursue this approach, be sure to check that the controller body provides the
## necessary interface by using GDScript's [code]hasMethod[/code] (a substitute
## for interface mechanisms provided by other coding languages).


## Notifies listeners of a change to the camera orientation
signal looked(Vector2, bool)
## Notifies listeners of a viewpoint switch (first- vs third-person)
signal changed(bool)

## Reference to a movement controller for the player character 
@export var controller:MovementController
## Reference to a transform a movement controller for the player character 
@export var follow_target:Node3D
## Controls how fast the camera moves relative to the input
@export var lookaround_speed = 0.01
## Maximum pitch angle
@export var top_clamp = 90
## Minimum pitch angle
@export var bottom_clamp = 0
# Third person camera position
@export var third_person_position:Vector3 = Vector3(0, 0, 5)

## Current yaw and pitch angles for this camera
var camera_rotation:Vector2


func _init():
	top_clamp = deg_to_rad(top_clamp)
	bottom_clamp = deg_to_rad(bottom_clamp)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _ready():
	connect("changed", controller.on_view_changed)
	connect("looked", controller.on_look)
	emit_signal("looked", 0)
	emit_signal("changed", is_first_person())


func _input(event):
	if event is InputEventMouseMotion:
		var view_delta = event.relative * lookaround_speed
		camera_rotation.x -= view_delta.x
		camera_rotation.y = clamp(camera_rotation.y + view_delta.y, bottom_clamp, top_clamp)
		look(camera_rotation)

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom(true)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom(false)


func _process(_delta):
	global_position = follow_target.global_position


## Indicates whether the camera view is in first-person mode
func is_first_person():
	return get_viewport().get_camera_3d().position.is_equal_approx(Vector3.ZERO)


## Orient the camera based on the given yaw and pitch angles
func look(angles:Vector2):
	transform.basis = Basis() # reset rotation
	rotate_object_local(Vector3.UP, angles.x) # then rotate in X
	rotate_object_local(Vector3.LEFT, angles.y) # then rotate in X
	emit_signal("looked", angles.x)


## Smoothly transition between first- and third-person views
func zoom(zoom_in:bool):
	var camera = get_viewport().get_camera()
	var tween = get_tree().create_tween()
	if zoom_in:
		tween.tween_property(camera, "translation", Vector3.ZERO, 0.2)
	else:
		tween.tween_property(camera, "translation", third_person_position, 0.2)
	emit_signal("changed", zoom_in)
