extends TextureProgressBar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = 100.0 * owner.health / owner.max_health
