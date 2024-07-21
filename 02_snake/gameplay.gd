extends Node2D


const START_POINT = Vector2i( 5, 5 )

var direction = Vector2i( -1, 0 )
const W = 10
const H = 10


var cur_number = 0
var number_pos: Vector2i
var snake = []

@onready var tile_map = $TileMap


#
# INIT
#

func _ready():
	draw_grid( )
	start( )


func start ( ):
	snake = [ START_POINT ]
	direction = Vector2i( -1, 0 )
	cur_number = 0
	time = 0
	draw_number( )
	draw_snake( )


#
# INPUT
#


func _unhandled_input ( event ):
	if event.is_action_pressed( "ui_left" ):
		direction = Vector2i( -1,  0 )
	elif event.is_action_pressed( "ui_right" ):
		direction = Vector2i(  1,  0 ) 
	elif event.is_action_pressed( "ui_up" ):
		direction = Vector2i(  0, -1 ) 
	elif event.is_action_pressed( "ui_down" ):
		direction = Vector2i(  0,  1 ) 

#
# LOGIC
#

var TIME_TO_MOVE = 0.5
var time = 0.0

func _process ( delta ):
	time -= delta
		
	if time < 0.0:
		time = TIME_TO_MOVE
		move( )

func move ( ):
	var head = snake[ 0 ]
	var max_length = cur_number * 3
	head += direction
	
	if out_of_limits( head ) or snake.has( head ):
		die( )
	else:
		snake.push_front( head )
	
		while snake.size( ) > max_length:
			snake.pop_back()
		
		draw_snake( )
		
		if head == number_pos:
			draw_number()
			if cur_number > 9:
				win( )

func out_of_limits ( head ):
	return head.x < 0 or head.x >= W or head.y < 0 or head.y > H

func die ( ):
	# TODO: do something dramatic
	start( )

func win ( ):
	# TODO: do something dramatic
	start( )

#
# RENDER
#

const L_GRID    = 0
const L_NUMBERS = 1
const L_SNAKE   = 2

func draw_grid ( ):
	for y in range( H ):
		for x in range( W ):
			tile_map.set_cell( L_GRID, Vector2i( x, y ), 0, Vector2i( 11, 0 ) )

func draw_number ( ):
	generate_number_position( )
	
	while snake.has( number_pos ):
		generate_number_position( )
	
	cur_number += 1
	print( "POSITON ", number_pos )
	tile_map.clear_layer( L_NUMBERS )
	tile_map.set_cell( L_NUMBERS, number_pos, 0, Vector2i( cur_number - 1, 0 ) )

func generate_number_position ( ):
	number_pos = Vector2i( randi_range( 0, W - 1 ), randi_range( 0, H - 1 ) )

func draw_snake ( ):
	tile_map.clear_layer( L_SNAKE )
	for i in range( snake.size( ) ):
		tile_map.set_cell( L_SNAKE, snake[ i ], 0, Vector2i( 10, 0 ) if i > 0 else Vector2i( 9, 0 ) )
