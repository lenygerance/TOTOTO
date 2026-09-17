extends Node2D

var temps_ecoule = 0.0
var jeu_fini = false
var distance_victoire = 30.0

func _ready():
	# Forcer la taille du conteneur à la taille de l'écran
	$ConteneurVictoire.size = get_viewport_rect().size
	
	# Étirer les labels sur toute la largeur (Ancre Wide Top)
	$ConteneurVictoire/VictoireLabel.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	$ConteneurVictoire/ConsigneLabel.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	
	# Alignement du texte au centre
	$ConteneurVictoire/VictoireLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$ConteneurVictoire/ConsigneLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# Placement aléatoire de la lune
	randomize()
	var ecran = get_viewport_rect().size
	var x_aleatoire = randf_range(100, ecran.x - 100)
	var y_aleatoire = randf_range(100, ecran.y - 100)
	$sprite_lune.position = Vector2(x_aleatoire, y_aleatoire)
	
	# Configuration de l'affichage de départ
	$ConteneurVictoire/VictoireLabel.visible = false
	$ConteneurVictoire/ConsigneLabel.text = "Trouve la Lune dans le ciel !"
	$ConteneurVictoire/ConsigneLabel.visible = true

func _process(delta):
	if not jeu_fini:
		temps_ecoule += delta
		$ChronoLabel.text = "Temps : " + "%.2f" % temps_ecoule
		verifier_victoire()

func verifier_victoire():
	var souris_pos = get_global_mouse_position()
	var lune_pos = $sprite_lune.position
	
	if souris_pos.distance_to(lune_pos) < distance_victoire:
		gagner_partie()

func gagner_partie():
	jeu_fini = true
	
	# Affichage de l'écran de victoire
	$ConteneurVictoire/VictoireLabel.text = "LUNE TROUVÉE EN " + "%.2f" % temps_ecoule + " SECONDES !"
	$ConteneurVictoire/VictoireLabel.visible = true
	
	$ConteneurVictoire/ConsigneLabel.text = "Appuie sur [R] pour rejouer  |  [Échap] pour quitter"
	$ConteneurVictoire/ConsigneLabel.visible = true

func _input(event):
	if jeu_fini and event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
			
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
