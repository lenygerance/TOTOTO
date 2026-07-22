extends Sprite2D

func _ready():
	# On cache la souris pour l'immersion
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var screen_size = get_viewport_rect().size # Maintenant 1280x720
	var image_size = texture.get_size() * scale # Prend en compte si tu as changé l'échelle
	
	# Calcul des limites pour ne jamais voir les bords de l'image
	var limit_x_min = screen_size.x - (image_size.x / 2.0)
	var limit_x_max = image_size.x / 2.0
	var limit_y_min = screen_size.y - (image_size.y / 2.0)
	var limit_y_max = image_size.y / 2.0

	# Application du clamp
	mouse_pos.x = clamp(mouse_pos.x, limit_x_min, limit_x_max)
	mouse_pos.y = clamp(mouse_pos.y, limit_y_min, limit_y_max)
	
	global_position = mouse_pos
