extends ParallaxBackground

@onready var parallax_layer: ParallaxLayer = $parallax_layer
@onready var texture: Sprite2D = $parallax_layer/texture

@export var direction: Vector2 = Vector2(-1, 1)
@export var move_speed: float = 32.0

func _process(delta: float) -> void:
	parallax_layer.motion_offset.x += direction.x * delta * move_speed
