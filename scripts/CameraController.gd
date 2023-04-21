extends Spatial

signal do_look(look)
signal do_turn(angle)

export var follow_target:NodePath
export var character_path:NodePath

export var third_person_pos:Vector3 = Vector3(0, 1.5, 5)
export var lookaround_speed:float = 0.01
export var top_clamp:float = 90
export var bottom_clamp:float = 0

var target:Spatial
var character:KinematicBody

var camera_rotation:Vector2
#var camera_pitch:float
#var camera_yaw:float


func _ready():
	target = get_node(follow_target)
	character = get_node(character_path)
	connect("do_turn", character, "on_turn")

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	top_clamp = deg2rad(top_clamp)
	bottom_clamp = deg2rad(bottom_clamp)


func _process(delta):
	global_translation = target.global_translation

func _input(event):
	if event is InputEventMouseMotion:
		var view_delta = -event.relative * lookaround_speed
		camera_rotation += view_delta
		camera_rotation.y = min(camera_rotation.y, -bottom_clamp)
		camera_rotation.y = max(camera_rotation.y, -top_clamp)
		look(camera_rotation)
#		if is_first_person():
		emit_signal("do_turn", global_rotation.y)
		
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom(true)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom(false)


func look(camera_rotation:Vector2):
	transform.basis = Basis.IDENTITY
	rotate_object_local(Vector3.UP, camera_rotation.x)
	rotate_object_local(Vector3.RIGHT, camera_rotation.y)
	
func zoom(zoom_in:bool):
	var camera = get_viewport().get_camera()
	if zoom_in:
		$Tween.interpolate_property(camera, "translation", camera.translation, Vector3.ZERO, 0.2)
	else:
		$Tween.interpolate_property(camera, "translation", camera.translation, third_person_pos, 0.2)
	$Tween.start()
