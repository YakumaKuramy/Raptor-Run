extends AnimatableBody2D

var death_time: float = 0.0

func _ready() -> void:
	death_time = Time.get_ticks_msec() + 2000


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() >= death_time:
		queue_free()


func  _physics_process(delta: float) -> void:
	var distance: Vector2 = Vector2.RIGHT * 1000 * delta
	var collision: KinematicCollision2D = move_and_collide(distance)
	
	if collision:
		queue_free()
		if collision.get_collider().is_in_group("enemy"):
			collision.get_collider().die()
		
