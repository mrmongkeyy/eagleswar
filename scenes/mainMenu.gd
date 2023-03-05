extends Node2D



func _on_play_button_down():
	get_tree().change_scene("res://scenes/smallWorld.tscn");

func _on_quit_button_down():
	get_tree().quit();
