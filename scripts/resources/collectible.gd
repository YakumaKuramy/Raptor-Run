extends Area2D


@export var value: float = 10.0
@export var amplitude: float = 50.0
@export var duration: float = 1.0 

@onready var game: Node2D = get_tree().get_root().get_node_or_null("/root/pixel_game")
@onready var animation: AnimatedSprite2D = $animation


func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	vertical_zigzag_forever(self)
	rotate_forever(self)


func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		game.add_score(value)
		animation.play("collected")
		animation.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	queue_free()


func rotate_forever(target: Node) -> void:
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_property(target, "rotation_degrees", 360.0, 2.0).as_relative().from(0.0)


func vertical_zigzag_forever(target: Node) -> void:
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	var original_y: int = target.global_position.y
	
	tween.tween_property(
		target,
		"global_position:y",
		original_y + amplitude,
		duration
	)
	
	tween.tween_property(
		target,
		"global_position:y",
		original_y - amplitude,
		duration
	)
