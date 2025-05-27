extends CharacterBody2D

@export var movement_speed: float = 50.0

@onready var animation: AnimatedSprite2D = $animation
@onready var hit_box: Area2D = $hit_box
@onready var player: CharacterBody2D = $"/root/main/player"
@onready var death_sound: AudioStreamPlayer = $death_sound

var active: bool = false
var gravity: float = 1600.0


func _ready() -> void:
	hit_box.body_entered.connect(_on_body_entered)
	player.player_died.connect(_on_player_died)


func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if not active:
		return
	
	velocity.x = -movement_speed
	velocity.y = gravity * delta
	
	move_and_slide()


func set_active(value: bool) -> void:
	active = value
	if active:
		animation.play("walk")


func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player") and active:
		player.die()


func _on_player_died() -> void:
	set_active(false)
	animation.play("idle")


func die() -> void:
	death_sound.play()
	animation.play("death")
	set_active(false)
	animation.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	queue_free()
