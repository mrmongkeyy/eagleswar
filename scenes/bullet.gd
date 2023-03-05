extends Node2D

var from;
var speed = 200;
export var timeleft = 50;
func _physics_process(delta):
	move(delta);
	_timeLeft();
func move(delta):
	var rad = rotation_degrees*PI/180;
	position.x += cos(rad)*speed*delta;
	position.y += sin(rad)*speed*delta;
func _timeLeft():
	timeleft -= 1;
	if(timeleft<=0):
		queue_free();
