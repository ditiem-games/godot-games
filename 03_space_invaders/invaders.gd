class_name invaders_c
extends Node2D

var rows = []

const INVADER_1 = preload("res://01_ships/invader_1.tscn")
const INVADER_2 = preload("res://01_ships/invader_2.tscn")
const INVADER_3 = preload("res://01_ships/invader_3.tscn")

# Called when the node enters the scene tree for the first time.
func _ready ( ) -> void:
	restart( )

var num_cols: int = 11
var max_offset: int = 0

func restart ( ):
	for row in rows:
		for inv in row:
			if inv:
				inv.queue_free( )
	
	rows = []
	max_offset = 0
	num_cols = 11
	create_row( INVADER_1 )
	create_row( INVADER_2 )
	create_row( INVADER_2 )
	create_row( INVADER_3 )
	create_row( INVADER_3 )
	compute_attack_line( )

var attack_line = []
func compute_attack_line ( ):
	attack_line = []
	attack_line.resize( num_cols )
	attack_line.fill( null )
	
	for y in range( rows.size() -1, 0, -1 ):
		for x in range( 0, num_cols ):
			if !attack_line[ x ] and rows[ y ][ x ]:
				attack_line[ x ] = rows[ y ][ x ]
				
		if !attack_line.has( null ):
			break

	#  need to remove all columns of attactline that are null
	

const ROW_HEIGHT = 16
const COL_WIDTH  = 16

func create_row ( invader ):
	max_offset += num_cols
	var y = (3 + rows.size()) * ROW_HEIGHT
	var r = []
	for i in range( num_cols ):
		var inv = invader.instantiate( )
		inv.on_invader_destroyed.connect( on_invader_destroyed )
		r.push_back( inv )
		inv.position = Vector2( engine_c.MARGIN + i * COL_WIDTH, y )
		add_child( inv )
	
	rows.push_back( r )

var freeze_time = 0.0

func on_invader_destroyed ( invader: invader_c ):
	for r in rows:
		var col = r.find( invader )
		
		if col >= 0:
			r[ col ] = null
			
			if attack_line[ col ] == invader:
				compute_attack_line( )

	freeze_time = .150
	
	owner.add_score( invader.score )

var time = 0
const STEP = 0.7
const SHOOT = 0.25
const MAX_ANI = 22

var attack_time = 0
const ATTACK_TIME = 1.050

func _process ( delta: float ) -> void:
	freeze_time -= delta
	
	if freeze_time > 0:
		return
	
	attack_time -= delta
	
	if attack_time <= 0:
		attack_time = ATTACK_TIME
		var i = randi_range( 0, attack_line.size( ) - 1 )
		attack_line[ i ].shoot( ) 
	
	time += delta
	
	if time > STEP:
		time -= STEP
		move_invaders( )

var prev_direction: int = 1 # 0 = down, -1 = left, 1 = right
var direction: int = 1 # 0 = down, -1 = left, 1 = right
var offset: int = 0

func move_invaders ( ):
	var n = 0
	var next_direction = direction

#	for i in range( 0, max_offset ):
	while n < MAX_ANI:
		var y_x: int = max_offset - offset - 1

		offset += 1
		
		if offset >= max_offset:
			offset = 0

			if direction == 0:
				next_direction = prev_direction * -1
			elif reached_limit( ):
				prev_direction = direction
				next_direction = 0
		
		var y: int = y_x / num_cols
		var x: int = y_x % num_cols
		
		var invader = rows[ y ][ x ]
		if invader:
			if direction == 0:
				invader.down( )
			else:
				invader.move( direction )
			n += 1
			
		direction = next_direction


func reached_limit ( ) -> bool:
	if !attack_line.size( ):
		return false

	var MAX_WIDTH = engine_c.SCREEN_WIDTH - ( (num_cols - 1) * COL_WIDTH + 2 * engine_c.MARGIN )
	
	var invader = attack_line[ 0 ]
	print( "CMP ", direction, " x:", invader.position.x, "  min: ", engine_c.MARGIN, " MAX: ", MAX_WIDTH )
	if direction > 0 and invader.position.x >= MAX_WIDTH:
		return true
	
	if direction < 0 and invader.position.x <= engine_c.MARGIN:
		return true
	
	return false
