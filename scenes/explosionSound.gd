extends AudioStreamPlayer2D
 
func _on_explosionSound_finished():
	queue_free();
