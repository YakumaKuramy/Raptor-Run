extends Area2D

@export var value: int = 3

@onready var animation: AnimatedSprite2D = $animation
@onready var pickup_sound: AudioStreamPlayer = $pickup_sound
@onready var player: CharacterBody2D = $"/root/main/player"

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player.add_ammo(value)
		animation.play("collected")
		pickup_sound.play()
		animation.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	queue_free()
