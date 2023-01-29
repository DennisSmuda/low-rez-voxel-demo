@tool
extends TextureRect

@onready var game_viewport = $GameViewport

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		pass # for viewing game/ui at the same time in editor
		# texture = game_viewport.get_texture() as ViewportTexture
		# texture.set_viewport_path_in_scene("GameTextureRect/GameViewport")
	else:
		texture = game_viewport.get_texture() as ViewportTexture
		texture.set_viewport_path_in_scene("GameTextureRect/GameViewport")
		

