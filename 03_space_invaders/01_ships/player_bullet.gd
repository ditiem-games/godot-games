class_name bullet_c
extends Node2D

@export var direction = -50
@onready var destruction_polygon: Polygon2D = $destruction_polygon
@onready var line_2d: Line2D = $Line2D
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	destruction_polygon.hide( )
	area_2d.area_entered.connect( on_area_entered )

func on_area_entered ( area: Area2D ):
	var body = area.get_parent( )
	
	if body is bullet_c:
		body.queue_free()
		queue_free()
	elif body is player_c:
		pass

func is_dead ( ):
	return direction == 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += direction * delta 
	
	if position.y < -4:
		queue_free()

func blow ( ):
	destruction_polygon.show( )
	direction = 0
	line_2d.hide( )
	var timer = Timer.new( )
	timer.wait_time = .15
	timer.autostart = true
	timer.timeout.connect( func( ): queue_free( ) )
	add_child( timer )
