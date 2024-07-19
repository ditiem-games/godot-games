class_name engine_c
extends Node2D

const SCREEN_WIDTH: int = 224
const SCREEN_HEIGHT: int = 256
const MARGIN: int = 10

var lifes: int = 3
var score: int = 0
var high_score: int = 0

func restart ( ):
	lifes = 3
	score = 0
	control.refresh( )


func add_score ( n ):
	score += n

@onready var control: Control = $Control

func on_player_destroyed ( ):
	lifes -= 1
	
	if lifes > 0:
		control.refresh( )
	else:
		# GAME OVER
		get_tree( ).reload_current_scene()
