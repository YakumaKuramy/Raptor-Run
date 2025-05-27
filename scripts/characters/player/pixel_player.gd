extends CharacterBody2D

signal  player_died

@export var gravity: float = 1600.0
@export var jump_power: float = 600.0

@onready var animation: AnimatedSprite2D = $animation
@onready var collision: CollisionShape2D = $collision
@onready var jump_sound: AudioStreamPlayer = $jump_sound
@onready var death_sound: AudioStreamPlayer = $death_sound
@onready var shoot_sound: AudioStreamPlayer = $shoot_sound
@onready var camera: Camera2D = $"/root/pixel_game/camera"
@onready var projectile_position: Node2D = $projectile_position
@onready var game: Node2D = $"/root/pixel_game/"

var projectile: PackedScene = preload("res://scenes/resource/projectile.tscn")

var active: bool = true
var was_jumpin: bool = false
var jump_pitch: float = 1.0
var jumps_remaining: int = 2
var ammo: int = 3


func _ready() -> void:
	animation.animation_finished.connect(_on_animation_finhished)


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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_attack") and ammo > 0 and active == true:
		var projectile_instance: AnimatableBody2D = projectile.instantiate()
		projectile_instance.position = projectile_position.global_position
		game.add_child(projectile_instance)
		animation.play("shoot")
		shoot_sound.play()
		ammo -= 1


func die() -> void:
	death_sound.play()
	animation.play("death")
	active = false
	collision.set_deferred("disabled", true)
	emit_signal("player_died")
 

func _on_animation_finhished() -> void:
	if animation.animation == "shoot":
		animation.play("run")


func add_ammo(amount: int) -> void:
	ammo += amount
