
extends Node3D

var WaterBlock = preload("res://scenes/water_block.tscn")

@onready var boat = get_node("../Boat")

var width: int = 32
var height: int = 32


var water = []
var counter = 0

var viewport_width
var viewport_height

var noise := FastNoiseLite.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	noise.frequency = 0.003
	
	water.append([])
	for x in range(width):
		water.append([])
		water[x]=[]
		for y in range(height):
			water[x].append([])
			var waterSprite: Node3D = WaterBlock.instantiate()
			
			waterSprite.position.x = (x * 0.4)
			waterSprite.position.z = (y * 0.4)
			
			water[x][y] = waterSprite
			add_child(waterSprite)



func _process(_delta):
	counter += 0.01
	
	boat.update_water_levels(noise, counter)

	# update water
	for x in range(width):
		for y in range(height):
			var waterSprite: Node3D = water[x][y]
			var new_height = noise.get_noise_3d(x + counter, 0, y + counter) - .5
			waterSprite.position.y = lerp(waterSprite.position.y, new_height, 0.2)

	if Input.is_action_just_pressed("increase_weather"):
		noise.fractal_gain += 0.2
	if Input.is_action_just_pressed("decrease_weather"):
		noise.fractal_gain -= 0.2
