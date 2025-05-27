extends Area2D

@export var value: float = 10.0

@onready var game: Node2D = $"/root/pixel_game"
@onready var animation: AnimatedSprite2D = $animation

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)


func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		game.add_score(value)
		animation.play("collected")
		animation.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	queue_free()
