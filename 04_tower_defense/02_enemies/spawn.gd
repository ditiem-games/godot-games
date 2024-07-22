extends Node2D

@export var waves: Array[ enemy_wave_c ] = []

@export var current_wave_index = 0
var current_wave_item_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var time = 0.0
var delay = 0.0

var enemies_spawned = 0

func _process ( delta: float ) -> void:
	if current_wave_index >= waves.size():
		return
	
	var current_wave = waves[ current_wave_index ]
	
	if current_wave_item_index >= current_wave.items.size( ):
		current_wave_item_index = 0
		current_wave_index += 1
		return
	
	var current_item = current_wave.items[ current_wave_item_index ]
	delay += delta
	
	if delay >= current_item.delay:
		time += delta
		
		if time >= current_item.frequency:
			time = 0
			spawn( current_item.enemy_type )
			if enemies_spawned >= current_item.amount:
				enemies_spawned = 0
				current_wave_item_index += 1

@onready var enemies: Node2D = $"../../enemies"

func spawn ( enemy: PackedScene ):
	var path = get_parent( )
	var new_enemy = enemy.instantiate( )
	new_enemy.path = path
	enemies.add_child( new_enemy )
	enemies_spawned += 1
	
