class_name player_c
extends Node2D

const SPEED = 1

func restart ( ):
	position = Vector2( engine_c.SCREEN_WIDTH / 2, position.y )

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "ui_accept" ):
		shoot( )

@onready var shooting_point: Node2D = $shooting_point
const PLAYER_BULLET = preload("res://01_ships/player_bullet.tscn")

var recharge_time = 0.0 ;

func shoot ( ):
	if recharge_time <= 0:
		var bullet = PLAYER_BULLET.instantiate( )
		get_tree().root.add_child( bullet )
		bullet.global_position = shooting_point.global_position
		
		recharge_time = 0.4 # 400 ms till we can shoot again

const MOVE_SLICE = 0.02
var time = 0.0

func _process ( delta: float ) -> void:
	time += delta
	recharge_time -= delta
	
	if time > MOVE_SLICE:
		time -= MOVE_SLICE
		position.x += SPEED * Input.get_axis( "ui_left", "ui_right" )

		position.x = clampi( int(position.x), engine_c.MARGIN, engine_c.SCREEN_WIDTH - 2 * engine_c.MARGIN )
