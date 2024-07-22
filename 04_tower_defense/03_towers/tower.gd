extends Node2D


enum state_e { placeholder, building, working }

@export var current_state: state_e = state_e.placeholder
@export var max_health: float = 100
@export var shoot_frequency: float = 0.5
@export var shoot_radius: float = 128:
	set ( new_radius ):
		shoot_radius = new_radius
		adjust_radius( )

@onready var shoot_area: Area2D = $shoot_area
@onready var collision_shape_2d: CollisionShape2D = $shoot_area/CollisionShape2D


var health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	adjust_radius( )
	health = max_health
	shoot_area.body_entered.connect( on_body_entered )
	shoot_area.body_exited.connect( on_body_exited )

func adjust_radius( ):
	if collision_shape_2d:
		(collision_shape_2d.shape as CircleShape2D).radius = shoot_radius

var shoot_at = []

func on_body_entered ( body ):
	shoot_at.push_back( body )

func on_body_exited ( body ):
	shoot_at.erase( body )
	
@onready var tower: Sprite2D = $tower

var reloading_time = 0

func _process ( delta: float ) -> void:
	reloading_time -= delta
	
	if shoot_at.size() > 0:
		tower.look_at( shoot_at[ 0 ].global_position )
		tower.rotate( PI / 2 )
		
		if reloading_time <= 0.0:
			shoot( shoot_at[ 0 ].global_position )
			reloading_time = shoot_frequency
		

const BULLET = preload("res://01_props/tower_bullet.tscn")
@onready var shooting_point: Node2D = $tower/shooting_point

func shoot ( to: Vector2 ):
	var from = shooting_point.global_position
	var bullet = BULLET.instantiate( )
	
	bullet.direction = (to - from).normalized()
	
	get_tree( ).root.add_child( bullet )
	bullet.global_position = from
