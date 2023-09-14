extends ParallaxBackground

func _process(delta):
	scroll_base_offset -= Vector2(1, 0) * delta
