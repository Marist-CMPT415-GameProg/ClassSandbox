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


## Notifies listeners of a change to the direction of motion
signal moved(Vector3, bool)
## Notifies listeners of a change in orientation
signal turned(float)
## Notifies a character when a jump action is initiated
signal jumped()
## ...
signal fallen
## ...
signal landed(Vector3, bool)
## Notifies a character upon entering or exiting a crouch
signal crouched(bool)
## Notifies listeners when switching between walk and run
signal sprinted(bool)

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
## Delay (in secs) before we consider a body to be falling (you know... for stairs!)
@export var fall_delay:float = 1
## Reference to character stamina attribute
@export var stamina:Stamina

## Vertical acceleration due to gravity
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

## The orientation the character is approaching
var target_angle:float = 0
## The direction of motion the character is approaching
var target_motion:Vector3 = Vector3.ZERO
## The speed of motion the character is approaching
var target_speed:float = walk_speed
## ...
var is_falling:bool = false
## ...
var fall_timeout:float


func _ready():
	fall_timeout = fall_delay


func _physics_process(delta):
	ground_check(delta)
	turn(delta)
	accelerate(delta)
	move_and_slide()


## Smoothly interpolate toward the target velocity and apply gravity.
func accelerate(delta):
	var dy = velocity.y
	var target_velocity = target_motion * target_speed
	velocity = lerp(velocity, target_velocity, delta * acceleration)
	velocity.y = dy - gravity * delta


## ...
func ground_check(delta):
	if is_on_floor():
		if is_falling:
			landed.emit(target_motion, target_speed == run_speed)
		is_falling = false
	else:
		fall_timeout -= delta 
		if fall_timeout <= 0:
			is_falling = true
			fall_timeout = fall_delay
			fallen.emit()


## Smoothly interpolate rotation toward the target angle
func turn(delta):
	var current_angle = rotation.y
	if abs(current_angle - target_angle) > 0.01:
		current_angle = lerp_angle(current_angle, target_angle, delta * turn_speed)
		rotation.y = current_angle


## Assign a direction of motion for the character
func move(force:Vector3, is_running:bool):
	target_motion = force.normalized()
	if target_motion.is_zero_approx():
		moved.emit(Vector3.ZERO, false)
		target_speed = 0
	else:
		moved.emit(target_motion, is_running)
		target_speed = run_speed if is_running else walk_speed


## Assign a direction of motion for the character
func on_moved(force:Vector3, is_running:bool):
	target_motion = force.normalized()
	target_speed = run_speed if is_running else walk_speed
	stamina.on_drain(not target_motion.is_zero_approx() and is_running)

## Assign a direction of motion for the character
func stop():
	target_motion = Vector3.ZERO
	target_speed = 0
	moved.emit(Vector3.ZERO, false)

## Assign a movement speed based on the current sprint and crouch states
func on_sprinted(sprint:bool):
	target_speed = run_speed if sprint else walk_speed
	stamina.on_drain(not target_motion.is_zero_approx() and sprint)

## Assign an orientation angle to indicate which direction the character faces
func orient(angle:float):
	target_angle = angle

## Apply a vertical jump impulse to the character velocity
func jump():
	var jump_force = sqrt(2.0 * jump_height * gravity)
	if is_on_floor():
		velocity.y += jump_force
		jumped.emit()


## Reduce character height and speed while crouching
func crouch(do_crouch:bool):
	target_speed = crouch_speed if do_crouch else walk_speed
	$StandingCollider.disabled = do_crouch
	$CrouchingCollider.disabled = not do_crouch
	crouched.emit(do_crouch)

