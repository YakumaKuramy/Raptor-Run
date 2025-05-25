extends Node2D

@export var world_sped: float = 300.0
@export var collectible_pitch_reset_interval: float = 2000.0

@onready var moving_environment: Node2D = $environment/moving
@onready var collect_sound: AudioStreamPlayer = $sounds/collect_sound
@onready var score_label: Label = $HUD/UI/score

var platform: PackedScene = preload("res://scenes/resource/platform.tscn")
var platform_collectible_single: PackedScene = preload("res://scenes/resource/platform_collectible_sigle.tscn")
var platform_collectible_row: PackedScene = preload("res://scenes/resource/platform_collectible_row.tscn")
var platform_collectible_rainbow: PackedScene = preload("res://scenes/resource/platform_collectible_rainbow.tscn")
 
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var last_platform_position: Vector2 = Vector2.ZERO
var next_spawn_time: float = 0.0
var collectible_pitch: float = 1.0
var reset_collectible_pitch_time: float = 0.0 
var score: int = 0


func _ready() -> void:
	rng.randomize()


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() > reset_collectible_pitch_time:
		collectible_pitch = 1.0
		
	if Time.get_ticks_msec() > next_spawn_time:
		spawn_next_platform()
		
	score_label.text = "Score: %s" % score


func _physics_process(delta: float) -> void:
	moving_environment.position.x -= world_sped * delta


func spawn_next_platform() -> void:
	var available_platforms: Array = [ 
		platform, 
		platform_collectible_single, 
		platform_collectible_row,
		platform_collectible_rainbow ]
	var platform_index: int = rng.randi_range(0, available_platforms.size() - 1)
	var new_platform: StaticBody2D = available_platforms[platform_index].instantiate()
	
	if last_platform_position == Vector2.ZERO:
		new_platform.position = Vector2(400, 0)
	else:
		var x: float = last_platform_position.x + rng.randi_range(450, 550)
		var y: float = clamp(last_platform_position.y + rng.randi_range(-150, 150), 200, 1000)
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
