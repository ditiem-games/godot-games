extends Area2D

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

var all_polygons = []
var all_collisions = []

func _ready() -> void:
	collision_polygon_2d.polygon = polygon_2d.polygon
	area_entered.connect( on_area_entered )
	all_polygons = [ polygon_2d ]
	all_collisions = [ collision_polygon_2d ]
	

func on_area_entered ( area ):
	var body = area.get_parent( )
	
	if body is bullet_c:
		if body.is_dead( ):
			return
			
		body.blow( )
		
		var rm_poly = (body.global_transform * body.destruction_polygon.polygon) * global_transform
		
		var parts: Array[ PackedVector2Array ] = []
		
		for poly in all_polygons:
			var new_parts = Geometry2D.clip_polygons( poly.polygon, rm_poly )
			parts.append_array( new_parts )
		
		for i in range( parts.size() ):
			var poly_area = polygon_area( parts[ i ] )
			print( "AREA: ", poly_area )
			
			if poly_area < 5.0:
				continue
			
			if i < all_polygons.size():
				all_polygons[ i ].set_deferred( "polygon", parts[ i ] )
				all_collisions[ i ].set_deferred( "polygon", parts[ i ] )
			else:
				create_part( parts[ i ] )
		
		while all_polygons.size( ) > parts.size( ):
			all_collisions.pop_back().queue_free( )
			all_polygons.pop_back().queue_free( )

func create_part ( points: PackedVector2Array ):
	var poly = Polygon2D.new( )
	poly.polygon = points
	poly.color = all_polygons[ 0 ].color
	add_child.call_deferred( poly )
	all_polygons.push_back( poly )
	
	var collision = CollisionPolygon2D.new( )
	collision.polygon = points
	add_child.call_deferred( collision )
	all_collisions.push_back( collision )

func polygon_area ( points: PackedVector2Array ) -> float:
	var A = 0.0
	var B = 0.0
	
	for i in range( 0, points.size( ) - 1 ):
		var cur = points[ i ]
		var next = points[ i + 1 ]
		A += cur.x * next.y
		B += cur.y * next.x
		
	return (A - B) / 2.0
