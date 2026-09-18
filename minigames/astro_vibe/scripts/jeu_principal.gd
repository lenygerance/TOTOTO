extends Node2D

@export var temps_max: float = 10.0
@export var distance_survol: float = 30.0 # Rayon de détection autour de la Lune

var temps_restant: float
var jeu_fini: bool = false

# Références aux nœuds
@onready var chrono_label: Label = $ChronoLabel
@onready var conteneur_victoire: Control = $ConteneurVictoire
@onready var victoire_label: Label = $ConteneurVictoire/VictoireLabel
@onready var defaite_label: Label = $ConteneurVictoire/DefaiteLabel
@onready var consigne_label: Label = $ConteneurVictoire/ConsigneLabel
@onready var lune: Sprite2D = $sprite_lune

func _ready() -> void:
	temps_restant = temps_max
	
	# Placement aléatoire de la Lune à chaque début de partie
	randomize()
	var ecran = get_viewport_rect().size
	var x_aleatoire = randf_range(100, ecran.x - 100)
	var y_aleatoire = randf_range(100, ecran.y - 100)
	lune.position = Vector2(x_aleatoire, y_aleatoire)
	
	# Afficher la consigne 
	conteneur_victoire.visible = true
	consigne_label.text = "TROUVE LA LUNE !"
	consigne_label.visible = true
	
	# Masquer les messages de fin
	victoire_label.visible = false
	defaite_label.visible = false
	
	# Alignement sur toute la largeur des labels
	victoire_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	defaite_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	consigne_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)

func _process(delta: float) -> void:
	if jeu_fini:
		return

	# Décompte (10s vers 0)
	temps_restant -= delta
	if temps_restant <= 0:
		temps_restant = 0
		afficher_defaite()
		return

	chrono_label.text = "Temps : " + str(snapped(temps_restant, 0.1))

	# Détection permanente du survol sur la Lune
	verifier_survol()

func verifier_survol() -> void:
	var souris_pos = get_global_mouse_position()
	if souris_pos.distance_to(lune.global_position) < distance_survol:
		valider_victoire()

func valider_victoire() -> void:
	jeu_fini = true
	consigne_label.visible = false
	victoire_label.text = "GAGNÉ, LUNE TROUVÉE EN " + str(snapped(temps_max - temps_restant, 0.1)) + " SECONDES !"
	victoire_label.visible = true

func afficher_defaite() -> void:
	jeu_fini = true
	consigne_label.visible = false
	defaite_label.text = "DOMMAGE !"
	defaite_label.visible = true
