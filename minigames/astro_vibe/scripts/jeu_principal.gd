extends Node2D

# Variables pour le jeu
var temps_ecoule = 0.0
var jeu_fini = false
var distance_victoire = 30.0 # La marge d'erreur (rayon du trou) en pixels

func _ready():
	# 1. Position aléatoire de la Lune
	randomize() # Important pour que ce soit différent à chaque lancement
	var ecran = get_viewport_rect().size
	
	# On définit des marges pour que la lune ne soit pas à moitié hors de l'écran
	# x entre 100 et 1180 (pour un écran de 1280)
	var x_aleatoire = randf_range(100, ecran.x - 100)
	var y_aleatoire = randf_range(100, ecran.y - 100)
	
	$sprite_lune.position = Vector2(x_aleatoire, y_aleatoire)
	
	# On cache le message de victoire au début
	$VictoireLabel.visible = false

func _process(delta):
	# Si le jeu n'est pas fini, on fait tourner le chrono
	if not jeu_fini:
		temps_ecoule += delta
		# On affiche le temps avec 2 chiffres après la virgule
		$ChronoLabel.text = "Temps : " + "%.2f" % temps_ecoule
		
		verifier_victoire()

func verifier_victoire():
	# Position de la souris (le centre du trou)
	var souris_pos = get_global_mouse_position()
	# Position de la lune
	var lune_pos = $sprite_lune.position
	
	# Calcule la distance entre la souris et la lune
	var distance = souris_pos.distance_to(lune_pos)
	
	# Si la distance est plus petite que notre marge (le joueur vise bien)
	if distance < distance_victoire:
		gagner_partie()

func gagner_partie():
	jeu_fini = true
	$VictoireLabel.text = "LUNE TROUVÉE EN " + "%.2f" % temps_ecoule + " SECONDES !" + " Appuies sur échap pour quitter !"
	$VictoireLabel.visible = true
	# Optionnel : jouer un son ici plus tard !
	

func _input(event):
	if event.is_action_pressed("ui_cancel"): # Touche Échap (ESC)
		get_tree().quit()
