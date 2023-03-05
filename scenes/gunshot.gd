extends AudioStreamPlayer2D



func _on_gunshot_finished():
	queue_free();
