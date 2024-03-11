extends RigidBody3D

var frozen = false

var space_landing = 0
@export var space_to_land = 0.06

var in_position = false

@onready var body = %Body

var random_speed = 0
var random_audio = 0

@onready var audio_player = $AudioStreamPlayer3D
@onready var click_audio_one = preload("res://Sounds/woodclick1.wav")
@onready var click_audio_two = preload("res://Sounds/woodclick2.wav")
@onready var click_audio_three = preload("res://Sounds/woodclick3.wav")

@onready var audio_array : Array = [click_audio_one, click_audio_two, click_audio_three]

var wood_click_sound

func _ready():
	self.name = "Coin"
	random_audio = randi_range(0, 2)
	wood_click_sound = audio_array[random_audio]
	audio_player.stream = wood_click_sound
	
	random_speed = randf_range(-10, 10)
	if space_landing > 0:
		space_to_land = (0.5 * space_landing) + 0.06


func _process(delta):
	if !freeze:
		update_coin_position.rpc(space_to_land, delta)


@rpc("any_peer", "call_local")
func update_coin_position(landing_space, delta):
	$Meshes.rotate_z(random_speed * delta)
	
	if global_position.y <= landing_space and !in_position:
		in_position = true
		global_position.y = landing_space
		freeze = true
		
		if audio_player != null:
			audio_player.playing = true
