extends Node3D

@onready var animator:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_body_moved(motion:Vector3, is_running:bool):
	if motion.is_zero_approx():
		match animator.current_animation:
			"CrouchedWalking":
				animator.play("IdleCrouchLeft")
			"Running":
				# QUEUE the Idle animation to run after the RunToStop animation
				animator.animation_set_next("RunToStop", "Idle")
				animator.play("RunToStop")
			"Walking":
				animator.play("Idle")
	else:
		match animator.current_animation:
			"JumpingUp", "FallingIdle":
				return
			"IdleCrouchLeft":
				$Node2.rotate_y(-90)
				animator.play("CrouchedWalking")
			_:
				animator.play("Running" if is_running else "Walking")


func on_body_crouched(is_on:bool):
	if is_on:
		match animator.current_animation:
			"Walking", "Running":
#				$Node2.rotate_y(90)
				animator.play("CrouchedWalking")
			"Idle":
				$Node2.rotate_y(90)
				animator.play("IdleCrouchLeft")
			_:
				$Node2.rotate_y(90)
				animator.play("IdleCrouchLeft")
	else:
		match animator.current_animation:
			"CrouchedWalking":
#				$Node2.rotate_y(-90)
				animator.play("Walking")
			"IdleCrouchLeft":
				$Node2.rotate_y(-90)
				animator.play("Idle")
			_:
				animator.play("Idle")


func on_body_jumped():
	animator.animation_set_next("JumpingUp", "FallingIdle")
	animator.play("JumpingUp")


func on_body_fallen():
	animator.play("FallingIdle")


func on_body_landed(motion:Vector3, is_running:bool):
	var next_anim:String
	if motion.is_zero_approx():
		next_anim = "Idle"
	else:
		next_anim = "Running" if is_running else "Walking"
	animator.animation_set_next("FallLandToStandingIdle", next_anim)
	animator.play("FallLandToStandingIdle")
