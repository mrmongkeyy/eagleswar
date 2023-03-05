extends Node2D

var enemyLen = 10;
var cloudsLen = 10;
onready var enemy = preload('res://scenes/plane.tscn');
onready var cloud = preload('res://scenes/cloud.tscn');
onready var planesImg = preload('res://scenes/planeSprite.tscn');
onready var playerInMapIndicator = preload('res://scenes/playerInMapIndicator.tscn');
onready var gameEnd = preload('res://scenes/gameEnd.tscn');
var putted = false;

func _ready():
	generatePlanes();
	Gclouds();
	mapSetup();

func _physics_process(delta):
	mapUpdate();
	winCodition();
	updateMoreMenu();
func Gclouds():
	for _i in range(cloudsLen):
		var c = cloud.instance();
		c.position = getObjectRandomPos();
		$clouds.add_child(c);
func winCodition():
	if($enemies.get_child_count()==1 and !putted):
		forceWin($enemies.get_children()[0].pilot);
		putted = true;
func generatePlanes():
	for _i in range(enemyLen):
		var e = enemy.instance();
		e.isEnemy = true;
		e.position = getObjectRandomPos();
		e.scale *= 0.01;
		$enemies.add_child(e);
func getObjectRandomPos():
	var rX = randi()%641;
	var rY = randi()%361;
	return Vector2(rX,rY);

func forceWin(name):
	if(global_.uiAnouncePutted):
		$UI.get_node("gameEnd").queue_free();
	var ge = gameEnd.instance();
	ge.get_node("Label").text = name+' win the wars';
	get_node("UI").add_child(ge);

func updateMoreMenu():
	$UI/moreMenu/killlabel.text = str(global_.data.You.kill);
	$UI/moreMenu/planeslabel.text = str($enemies.get_child_count());
var mapObjects = {};

func mapSetup():
	#adding the enemy inside of listObj.
	for i in $enemies.get_children():
		var name = i.name.replace('@','');
		mapObjects[name] = i;
		i.thisName = name; 
	for i in mapObjects:
		var obj = planesImg.instance();
		if(i=='plane'):
			var playerINMAPINDICATOR = playerInMapIndicator.instance();
			obj.add_child(playerINMAPINDICATOR);
		obj.name = i;
		obj.position = mapObjects[i].position;
		obj.rotation_degrees = mapObjects[i].rotation_degrees;
		$UI/maps/objs.add_child(obj);
func mapUpdate():
	for i in $UI/maps/objs.get_children():
		if(mapObjects[i.name]):
			i.position = mapObjects[i.name].position;
			if(i.name!='plane'):
				i.rotation_degrees = mapObjects[i.name].rotation_degrees;
