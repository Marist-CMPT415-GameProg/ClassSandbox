class_name BotController
extends CharacterBody3D

@export var moveSpeed:float
@export var health:float
@export var healthRate:float
@export var detectDistance:float
@export var projectile:Node3D #TODO: make this our own class
@onready var animPlayer = get_node("AnimationPlayer")
@onready var audioPlayer = get_node("AudioStreamPlayer3D")
var direction:Vector3
var player

func _ready():
	player = get_node("../Player")

func _process(delta):
	animPlayer.play("walk")
	position = position.move_toward(player.position, moveSpeed * delta)
