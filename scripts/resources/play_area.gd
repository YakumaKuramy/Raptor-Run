extends Area2D

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)


func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		body.set_active(true)


func _on_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("enemy"):
		body.queue_free()
