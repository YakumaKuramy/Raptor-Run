extends VBoxContainer

@onready var start_button: Button = $start_button
@onready var exit_button: Button = $exit_button


func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_scenes/main.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
