class_name Character
extends KinematicBody

signal sprinted(value) # value is bool indicating sprint/true or walk/false

export var WALK_SPEED    = 2.0
export var RUN_SPEED     = 5.0
export var JUMP_HEIGHT   = 1.0
export var CROUCH_HEIGHT = 0.5
export var CROUCH_SPEED_MODIFIER = 0.5

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

var velocity:Vector3
var direction:Vector3

var target_speed:float = WALK_SPEED # the speed that the character wants to move
var is_crouching:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var speed = CROUCH_SPEED_MODIFIER * WALK_SPEED if is_crouching else target_speed
	velocity.x  = direction.x * speed
	velocity.y -= gravity * delta
	velocity.z  = direction.z * speed
	velocity = move_and_slide(velocity, Vector3.UP)

func on_move(input_dir:Vector2):
	direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	direction = direction.normalized()

func on_sprint(sprint:bool):
	if sprint:
		target_speed = RUN_SPEED if target_speed == WALK_SPEED else WALK_SPEED
		emit_signal("sprinted", target_speed == RUN_SPEED)

func on_turn(angle:float):
	rotation.y = angle

func on_jump():
	if is_on_floor():
		velocity.y += sqrt(2 * JUMP_HEIGHT * gravity)

func on_crouch(crouch:bool):
	var crouch_scale = Vector3(1, CROUCH_HEIGHT, 1)
	if crouch:
		if scale.is_equal_approx(Vector3.ONE):
			is_crouching = true
			$Tween.interpolate_property(self, "scale", scale, crouch_scale, 0.2)
		else:
			is_crouching = false
			$Tween.interpolate_property(self, "scale", scale, Vector3.ONE, 0.2)
		$Tween.start()

