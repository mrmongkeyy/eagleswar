extends Node2D

export var speed = 0.1;
export var dir = 1;
func _physics_process(delta):
	updatePos();
	
func updatePos():
	position.x -= speed*dir;
	if(position.x-320 >= 1280+320):
		position.x = -1280+320;
	elif(position.x+320 <= -1280+320):
		position.x = 1280+320;
