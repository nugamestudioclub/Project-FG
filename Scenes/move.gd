extends Node

class_name Move

@export var input : StringName

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@export var animation_name: String

@onready var player := owner as FGCharacter
@onready var controller := get_parent()

var frame := 0

func _ready() -> void:
	animation_player.animation_finished.connect(func(): controller.change_move("Idle"))

func begin() -> void:
	frame = 0
	animation_player.stop()
	animation_player.assigned_animation = animation_name
	animation_player.advance(0)
	_on_start()

func play() -> void:
	_on_tick()
	
	animation_player.advance(1)
	frame += 1

func end() -> void:
	_on_finish()

func _on_start() -> void:
	pass

func _on_tick() -> void:
	pass

func _on_finish() -> void:
	pass
