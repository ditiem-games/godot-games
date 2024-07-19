extends Control

@onready var lifes: HBoxContainer = $lifes

const SHIP_LIFE = preload("res://ship_life.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh( )

var lifes_sprites = []

func add_life ( ):
	var new_life = SHIP_LIFE.instantiate()
	lifes.add_child( new_life )
	lifes_sprites.push_back( new_life )

func refresh ( ):
	while lifes_sprites.size( ) > owner.lifes:
		lifes_sprites.pop_front().queue_free( )

	while lifes_sprites.size( ) < owner.lifes:
		add_life( )


@onready var score_lbl: Label = $score_lbl

func _process(delta: float) -> void:
	score_lbl.text = "%4d" % [ owner.score ]
