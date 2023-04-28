class_name Character
extends CharacterBody3D

## Provides various common mechanics for a 3D character based on kinematic control.
##
## Implements smooth changes in speed and direction of motion via interpolation
## between current and target values. Mechancis currently included are: basic
## locomotion (e.g., walking), turning, sprinting, crouching (e.g., sneak), and
## jumping. The demo version of crouching in this script relies on the Godot 4
## style of tweening that was back-ported to Godot 3.5. Alternatively, we could
## use a Tween node (e.g., attached under the character body itself).


## Base speed (in m/sec) for normal movement such as walking
@export var walk_speed:float    = 2.0
## Speed when sprinting (in m/sec)
@export var run_speed:float     = 5.0
## Turning speed (in deg/sec)
@export var turn_speed:float    = 5.0
## Speed when crouching (in m/sec)
@export var crouch_speed:float  = 1.0
## Relative height of the character avatar while crouching
@export var crouch_height:float = 0.5
## Relative height the character can jump to
@export var jump_height:float   = 1.5
## How fast the character changes movement speeds
@export var acceleration:float  = 10

## Vertical acceleration due to gravity
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

## The orientation the character is approaching
var target_angle:float = 0
## The direction of motion the character is approaching
var target_motion:Vector3 = Vector3.ZERO
## The speed of motion the character is approaching
var target_speed:float = walk_speed


func _physics_process(delta):
	turn(delta)
	accelerate(delta)
	move_and_slide()


## Smoothly interpolate toward the target velocity and apply gravity.
func accelerate(delta):
	var dy = velocity.y
	var target_velocity = target_motion * target_speed
	velocity = lerp(velocity, target_velocity, delta * acceleration)
	velocity.y = dy - gravity * delta


## Smoothly interpolate rotation toward the target angle
func turn(delta):
	var current_angle = rotation.y
	if abs(current_angle - target_angle) > 0.01:
		current_angle = lerp_angle(current_angle, target_angle, delta * turn_speed)
		rotation.y = current_angle


## Assign a direction of motion for the character
func on_move(force:Vector3):
	target_motion = force.normalized()


## Assign a movement speed based on the current sprint and crouch states
func on_sprint(sprint:bool):
	target_speed = run_speed if sprint else walk_speed


## Assign an orientation angle to indicate which direction the character faces
func on_turn(angle:float):
	target_angle = angle


## Apply a vertical jump impulse to the character velocity
func on_jump():
	var jump_force = sqrt(2.0 * jump_height * gravity)
	if is_on_floor():
		velocity.y += jump_force


## Reduce character height and speed while crouching
func on_crouch(do_crouch:bool):
	var tween = get_tree().create_tween()
	if do_crouch:
		target_speed = crouch_speed
		tween.tween_property(self, "scale", Vector3(1, crouch_height, 1), 0.1)
	else:
		target_speed = walk_speed
		tween.tween_property(self, "scale", Vector3.ONE, 0.1)
