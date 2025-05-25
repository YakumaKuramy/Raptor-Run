extends CharacterBody2D

@export var gravity: float = 1600.0
@export var jump_power: float = 600.0

@onready var animation: AnimatedSprite2D = $animation
@onready var jump_sound: AudioStreamPlayer = $jump_sound
@onready var camera: Camera2D = $"/root/main/camera"

var active: bool = true
var was_jumpin: bool = false
var jumps_remaining: int = 2
var jump_pitch: float = 1.0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	if active:
		camera.position = position
		if was_jumpin and is_on_floor():
			was_jumpin = false
			jumps_remaining = 2
			animation.play("run")
			jump_pitch = 1.0
		if Input.is_action_just_pressed("ui_up") and jumps_remaining > 0:
			jumps_remaining -= 1
			was_jumpin = true
			velocity.y -= jump_power
			
			if jumps_remaining == 1:
				animation.play("jump")
			else:
				animation.play("double_jump")
			
			jump_sound.set_pitch_scale(jump_pitch)
			jump_sound.play()
			jump_pitch += 0.2
	move_and_slide() 
