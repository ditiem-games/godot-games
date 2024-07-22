class_name enemy_c
extends Node2D


@export var max_health = 50
var health

@export var path: Path2D
@export var speed: float = 128 # px / sec


var path_follow: PathFollow2D

func _ready() -> void:
	health = max_health
	path_follow = PathFollow2D.new( )
	path.add_child( path_follow )

@onready var sprite_2d: Sprite2D = $Sprite2D

func destroy ( ):
	path_follow.queue_free()
	queue_free()

func _process ( delta: float ) -> void:
	path_follow.progress += speed * delta
	global_position = path_follow.global_position
	sprite_2d.global_rotation = path_follow.global_rotation
	if path_follow.progress_ratio >= .95:
		# we reached the end, so someone forgot some escape area somewhere
		destroy( )


func increase_damage ( damage: float ):
	health -= damage
	if health <= 0.0:
		queue_free( )
