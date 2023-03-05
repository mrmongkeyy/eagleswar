extends CanvasLayer
onready var anouncingLable = preload('res://scenes/anounceLabel.tscn');
var listAnouncing = [];

func displayAnounce():
	for i in range(len(listAnouncing)):
		var al = anouncingLable.instance();
		al.get_node("Label").text = listAnouncing[i];
		al.position = Vector2(8,40+(i*20));
		add_child(al);
func _ready():
	displayAnounce();



func _on_Timer_timeout():
	displayAnounce();
