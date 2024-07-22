class_name bullet_c
extends CharacterBody2D

@export var speed    = 300.0
@export var max_time = 2.0
@export var direction: Vector2 = Vector2.ZERO
@export var damage   = 20.0

func _ready ( ):
	velocity = direction * speed

var time = 0.0

func _physics_process ( delta: float ) -> void:
	time += delta
	
	if time >= max_time:
		queue_free()
	else:
		var collision = move_and_collide( velocity * delta )
		
		if collision:
			var enemy = collision.get_collider() #.get_parent( )
			
			if enemy.has_method( "increase_damage" ):
				enemy.increase_damage( damage )
				
			queue_free( )
