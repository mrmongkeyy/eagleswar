extends CanvasLayer

func _on_Button_button_down():
	global_.resetData();
	get_tree().change_scene("res://scenes/smallWorld.tscn");


func _on_menuButton_button_down():
	get_tree().change_scene("res://scenes/mainMenu.tscn");
