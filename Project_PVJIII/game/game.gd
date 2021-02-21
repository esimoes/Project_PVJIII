tool
extends Spatial

signal replace_main_scene
signal quit

onready var bike = $Bike
onready var tempBar_progress = get_node("ui_game/bikeSteering/tempBar")
onready var popup = get_node("ui_game/Container")

var ramp_load = load("res://objects/ramp.tscn")
var road_load = load("res://scene/scene.tscn")
var goal_load = load("res://goal/goal.tscn")
var mud_load = load("res://objects/mud.tscn")

var road = []
var bikePos = Vector3(0,0,0)
var laps = 0
var win = false

## el vector nivel setea cada elemento dentro de la pista 1,2 y 3 son las rampas,4 y 5 reservados, 6 lodo ,9 lap y 10 Goal
var lvl = [0,6,2,0,1,1,1,9,0,0,6,3,0,2,2,9,2,6,0,1,0,1,6,9,1,0,3,0,3,0,0,2,0,10] 
var record = 82.0
##-------------------------

const SIZE_ROAD = 6
const DISTANCE_OBJECT = 20

func _ready():
	bikePos = bike.translation  + Vector3(24,-bike.translation.y,0)
	if not Engine.editor_hint:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for i in range(SIZE_ROAD):
		road.append(road_load.instance())
		road[i].translation = bikePos - Vector3(12*i,0,0)
		add_child(road[i])
	for i in lvl.size():
		if lvl[i] != 0:
			if lvl[i] == 9:
				var goal = goal_load.instance()
				goal.translation = Vector3(-DISTANCE_OBJECT * i,0,0)
				laps+=1
				goal.set_lap(laps)
				add_child(goal)
			if lvl[i] == 10:
				var goal = goal_load.instance()
				goal.translation = Vector3(-DISTANCE_OBJECT * i,0,0)
				laps+=1
				goal.set_lap(laps)
				goal.set_total_laps(laps)
				add_child(goal)
			if lvl[i] == 6:
				var mud = mud_load.instance()
				mud.translation = Vector3(-DISTANCE_OBJECT * i,0,1)
				add_child(mud)
			else:
				var ramp = ramp_load.instance()
				ramp.translation = Vector3(-DISTANCE_OBJECT * i,0,0)
				ramp.set_ramp(lvl[i])
				add_child(ramp)


func _process(_delta):
	if not Engine.editor_hint:
		tempBar_progress.value = bike.get_temperature()
		_procedural_map()
		
		if bike.finish && !popup.visible:
			popup.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			show_win()


func _procedural_map():
	var auxP = bike.translation.distance_to(road[0].get_translation())
	if auxP > 36.0:
		var r = road.pop_front()
		r.translation.x -= 72
		road.push_back(r)

func get_level_laps():
	return laps
	
func get_record_time():
	return record
	
func check_record_time(_time):
	if record >= _time:
		return false

func _on_Container_quit():
	emit_signal("quit")

func _on_Container_replace_main_scene(resource : Resource):
	emit_signal("replace_main_scene",resource)
	
func show_win():
	if record >= bike.get_time():
		win = true
	else:
		win = false

func get_win():
	return win
