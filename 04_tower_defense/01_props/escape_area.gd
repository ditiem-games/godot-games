extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect( on_enemy_escaped )


func on_enemy_escaped ( enemy ):
	enemy.destroy( )
	# TODO: decrease the max allowed enemies and if it reaches 0 it is game over
