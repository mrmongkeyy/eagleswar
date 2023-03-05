extends Node

var pilotnames = [
	'gema','caca',
	'moses','thania',
	'latesha','frugo',
	'danilo','kara',
	'marela','damian',
	'leo','augusto'
];
var data = {
	'You':{'kill':0},
};
var uiAnouncePutted = false;
func resetData():
	data = {'You':{'kill':0}}
func resetNames():
	return [
		'gema','caca',
		'moses','thania',
		'latesha','frugo',
		'danilo','kara',
		'marela','damian',
		'leo','augusto'
	];
func getName():
	var index = randi()%len(pilotnames);
	var name = pilotnames[index];
	pilotnames.remove(index);
	if(len(pilotnames)==0):
		pilotnames = resetNames();
	data[name] = {'kill':0};
	return name;
