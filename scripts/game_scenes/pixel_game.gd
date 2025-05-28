extends Node2D

signal game_over

@export var world_sped: float = 300.0
@export var collectible_pitch_reset_interval: float = 2000.0

@onready var moving_environment: Node2D = $environment/moving
@onready var collect_sound: AudioStreamPlayer = $sounds/collect_sound
@onready var score_label: Label = $HUD/UI/score
@onready var ammo_label: Label = $HUD/UI/ammo
@onready var game_over_label: Label = $HUD/UI/game_over
@onready var player: CharacterBody2D = $pixel_player
@onready var ground: Area2D = $environment/static/ground

var platform: PackedScene = preload("res://scenes/resource/platform.tscn")
var platform_enemy: PackedScene = preload("res://scenes/resource/platform_enemy.tscn")
var platform_collectible_single: PackedScene = preload("res://scenes/resource/platform_collectible_sigle.tscn")
var platform_collectible_row: PackedScene = preload("res://scenes/resource/platform_collectible_row.tscn")
var platform_collectible_rainbow: PackedScene = preload("res://scenes/resource/platform_collectible_rainbow.tscn")
var platform_collectible_ammo: PackedScene = preload("res://scenes/resource/platform_collectible_ammo.tscn")
 
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var last_platform_position: Vector2 = Vector2.ZERO
var next_spawn_time: float = 0.0
var collectible_pitch: float = 1.0
var reset_collectible_pitch_time: float = 0.0 
var score: int = 0


func _ready() -> void:
	rng.randomize() 
	player.player_died.connect(_on_player_died)
	ground.body_entered.connect(_on_ground_body_entered)
	var os_name: String = OS.get_name()
	
	if os_name == "Android":
		pass
	elif os_name == "Web":
		pass
	elif os_name == "Windows":
		pass
	else:
		print("SO não identificadoe ")


func _process(_delta: float) -> void:
	if not player.active:
		if Input.is_action_just_pressed("ui_up"):
			get_tree().reload_current_scene()
		return
		
	if Time.get_ticks_msec() > reset_collectible_pitch_time:
		collectible_pitch = 1.0
		
	if Time.get_ticks_msec() > next_spawn_time:
		spawn_next_platform()
		
	score_label.text = "Score: %s" % score
	ammo_label.text = "Ammo: %s" % player.ammo


func _physics_process(delta: float) -> void:
	if not player.active:
		return
	moving_environment.position.x -= world_sped * delta


func spawn_next_platform() -> void:
	var available_platforms: Array = [ 
		platform,
		platform_enemy, 
		platform_collectible_single, 
		platform_collectible_row,
		platform_collectible_rainbow,
		platform_collectible_ammo, ]
	
	var platform_index: int = rng.randi_range(0, available_platforms.size() - 1)
	var new_platform: StaticBody2D = available_platforms[platform_index].instantiate()
	
	if last_platform_position == Vector2.ZERO:
		new_platform.position = Vector2(108, 0)
	else:
		var x: float = last_platform_position.x + rng.randi_range(54, 108)
		#var x: float = last_platform_position.x + rng.randi_range(450, 550)
		#var y: float = clamp(last_platform_position.y + rng.randi_range(-150, 150), 200, 1000)
		var y: float = clamp(last_platform_position.y + rng.randi_range(-27, 54), 27, 108)
		new_platform.position = Vector2(x, y)
	
	moving_environment.add_child(new_platform)
	
	last_platform_position = new_platform.position
	next_spawn_time += world_sped


func add_score(value: int) -> void:
	score += value
	collect_sound.set_pitch_scale(collectible_pitch)
	collect_sound.play()
	collectible_pitch += 0.1
	reset_collectible_pitch_time = Time.get_ticks_msec() + collectible_pitch_reset_interval


func _on_player_died() -> void:
	emit_signal("game_over")
	game_over_label.text = game_over_label.text % score
	game_over_label.set_visible(true)


func _on_ground_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		player.die()
