extends Node3D

var WaterBlock = preload("res://scenes/water_block.tscn")

@onready var boat = get_node("../Boat")

var noise := FastNoiseLite.new()

var width: int = 32
var height: int = 32

var water = []
var counter = 0


func _ready():
	noise.frequency = 0.003
	noise.fractal_gain = 2
	
	water.append([])
	for x in range(width):
		water.append([])
		water[x]=[]
		for y in range(height):
			water[x].append([])
			var water_block: Node3D = WaterBlock.instantiate()
			
			water_block.position.x = (x * 0.4)
			water_block.position.z = (y * 0.4)
			
			water[x][y] = water_block
			add_child(water_block)


func _process(_delta):
	counter += 0.01
	
	boat.update_water_levels(noise, counter)
	handle_weather_inputs()

	for x in range(width):
		for y in range(height):
			var water_block: Node3D = water[x][y]
			var new_height = noise.get_noise_3d(x + counter, 0, y + counter) - .5
			water_block.position.y = lerp(water_block.position.y, new_height, 0.2)


func handle_weather_inputs():
	if Input.is_action_just_pressed("increase_weather"):
		noise.fractal_gain += 0.2
	if Input.is_action_just_pressed("decrease_weather"):
		noise.fractal_gain -= 0.2
