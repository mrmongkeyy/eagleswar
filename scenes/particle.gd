extends Node2D


export var timeLeft = 15;
export var sAmount = 0.2;
func _physics_process(delta):
	life();
	scale();
func life():
	timeLeft-=1;
	if(timeLeft<=0):
		queue_free();
func scale():
	scale.x += sAmount;
	scale.y += sAmount;
