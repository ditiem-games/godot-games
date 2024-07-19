class_name invader_c
extends Sprite2D

signal on_invader_destroyed ( )

@export var score: = 40
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.area_entered.connect( on_area_entered )
	pass # Replace with function body.

const EXPLOSION = preload("res://00_assets/explosion.png")

func on_area_entered ( area: Area2D ):
	var body = area.get_parent( )
	
	if body is bullet_c:
		body.queue_free()
		hframes = 1
		texture = EXPLOSION
		frame = 0
		collision_shape_2d.set_deferred( "disabled", true )
		on_invader_destroyed.emit( self )
		var timer = Timer.new( )
		timer.wait_time = 0.5
		timer.autostart = true
		timer.timeout.connect( func ( ):
			queue_free( )
			)
		add_child( timer )
	# is body is wall_c => game over

func move ( dir ):
	position.x += dir * 4
	frame = (frame + 1) % 2

func down ( ):
	position.y += invaders_c.ROW_HEIGHT

@onready var shooting_point: Node2D = $shooting_point
const INVADER_BULLET = preload("res://01_ships/invader_bullet.tscn")

var recharge_time = 0.0 ;

func shoot ( ):
	var bullet = INVADER_BULLET.instantiate( )
	get_tree().root.add_child( bullet )
	bullet.global_position = shooting_point.global_position
