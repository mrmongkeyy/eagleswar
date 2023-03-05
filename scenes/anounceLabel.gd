extends Node2D

func _on_Timer_timeout():
	get_parent().listAnouncing.pop_front();
	queue_free();
