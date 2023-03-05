extends Node2D

var speed = 50;
var rSpeed = 3;
var thisName;
var pilot = 'You';
var enemyCanAttack = false;
export var isEnemy = false;
onready var particle = preload('res://scenes/particle.tscn');
onready var bullet = preload('res://scenes/bullet.tscn');
onready var explode = preload('res://scenes/explode.tscn');
onready var gameEnd = preload('res://scenes/gameEnd.tscn');
onready var sounds = {
	'gun':preload('res://scenes/gunshot.tscn'),
	'explode':preload('res://scenes/explosionSound.tscn')
}
func _ready():
	if(!isEnemy):
		generateEnemyMoveProps();
	else:
		$PlayerAditional.queue_free();
		pilot = global_.getName();
	addInfo(pilot+' joined the war.');
func _physics_process(delta):
	#handleRotationMouse();
	handleattack();
	handleEnemyAttack();
	#this section will be great!.
	if(!isEnemy):
		playerGetEnemyDir();
	move(delta);
	handleLimitMap();
	putParticles();
	
class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false
func handleattack():
	if(!isEnemy and Input.is_action_just_pressed("ui_accept")):
		spawnBullet();
		putSound('gun');
func handleEnemyAttack():
	if(isEnemy and enemyCanAttack):
		spawnBullet();
		enemyCanAttack = false;
func spawnBullet():
	var b = bullet.instance();
	b.position = $shootPos.global_position;
	b.rotation_degrees = rotation_degrees;
	b.from= pilot;
	get_parent().get_parent().get_node("bullets").add_child(b);
func move(delta):
	#handling rotatin input.
	if(!isEnemy):
		if(Input.is_action_pressed("ui_left")):
			rotation_degrees -= rSpeed;
		elif(Input.is_action_pressed("ui_right")):
			rotation_degrees += rSpeed;
	else:
		enemyMove();
	#handling the movement.
	var rad = (rotation_degrees)*PI/180; 
	position.x += cos(rad)*speed*delta;
	position.y += sin(rad)*speed*delta; 
func putParticles():
	#left
	var pleft = particle.instance();
	pleft.position = $left.global_position;
	get_parent().get_parent().get_node("particles").add_child(pleft);
	#right
	var pright = particle.instance();
	pright.position = $right.global_position;
	get_parent().get_parent().get_node("particles").add_child(pright);
func handleRotationMouse():
	#finding the len of player pos and the mouse pos.
	var mousePos = get_global_mouse_position();
	var newTriangle = {'x':mousePos.x-position.x,'y':mousePos.y-position.y};
	var m = sqrt(newTriangle.x*newTriangle.x+newTriangle.y*newTriangle.y);
	if(m>200):
		look_at(mousePos);
func handleLimitMap():
	if(position.x >= 640):
		position.x = 0;
	elif(position.x <= 0):
		position.x = 640;
	elif(position.y >= 360):
		position.y = 0;
	elif(position.y <= 0):
		position.y = 360;
var enemyMoveDir = 0;
#personalities.
var moveDirLists = [-1,1,-1,0,0,1];
var timeMovements = [20,10,40,30,50,60,45];
#the end of personalities.
export var enemyMoveSpeed = 3;
var enemyMoveTimeleft = 0;
func generateEnemyMoveProps():
	enemyMoveDir = moveDirLists[randi()%len(moveDirLists)];
	enemyMoveTimeleft = timeMovements[randi()%len(timeMovements)];
func enemyMove():
	#i dont have an idea.
	if(enemyMoveTimeleft>0):
		#the enemy still having time to move that dir.
		rotation_degrees += enemyMoveSpeed*enemyMoveDir;
		enemyMoveTimeleft -= 1;
	else:
		generateEnemyMoveProps();
func handleMapLimitBounce():
	if(position.x >= 640):
		rotation_degrees *= -1;

func getLen(a,b):
	var newA = b.position.x-a.position.x;
	var newB = b.position.y-a.position.y;
	return sqrt(newA*newA+newB*newB);

func playerGetEnemyDir():
	var Objs = get_parent().get_children();
	var player = Objs[0];
	var enemies = Objs.slice(1,len(Objs));
	var lens = [];
	for i in enemies:
		lens.append([getLen(player,i),i]);
	if(len(lens)==0):
		$PlayerAditional/enemyIndicator.rotation_degrees = 0;
		return
	lens.sort_custom(MyCustomSorter,'sort_ascending');
	$PlayerAditional/enemyIndicator.look_at(lens[0][1].position);
func _on_2dBody_area_entered(area):
	if(area.is_in_group('plane')):
		global_.data[area.get_parent().pilot].kill += 1;
		killingInfo(area.get_parent().pilot,pilot);
	elif(area.is_in_group('bullet')):
		#giving signal.
		global_.data[area.get_parent().from].kill += 1;
		killingInfo(area.get_parent().from,pilot);
	else:
		return
	putExplode();
	putSound('explode');
	gone();

func killingInfo(a,b):
	var info = a+' kill '+b;
	get_parent().get_parent().get_node("UI/uiAnounce").listAnouncing.append(info);

func addInfo(text):
	get_parent().get_parent().get_node("UI/uiAnounce").listAnouncing.append(text);

func putExplode():
	var e = explode.instance();
	e.position = position;
	get_parent().get_parent().get_node("explodes").add_child(e);

func putSound(name):
	var s = sounds[name].instance();
	get_parent().get_parent().get_node("audios").add_child(s);

func gone():
	if(!isEnemy):
		global_.uiAnouncePutted = true;
		gameEndProcess();
	get_parent().get_parent().get_node("UI/maps/objs").get_node(thisName).queue_free();
	queue_free();

func gameEndProcess():
	get_parent().get_parent().get_node("UI/moreMenu/Pause").queue_free();
	var ge = gameEnd.instance();
	get_parent().get_parent().get_node("UI").add_child(ge);

func _on_attacking_area_area_entered(area):
	if(isEnemy and area.get_parent().is_in_group('enemy')):
		enemyCanAttack = true;

func _on_attacking_area_area_exited(area):
	if(isEnemy and area.get_parent().is_in_group('enemy')):
		enemyCanAttack = false;
