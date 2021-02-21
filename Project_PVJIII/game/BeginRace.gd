extends Node


onready var waiting = get_node("waitng")
onready var countdown = get_node("start")

var timeCountdownSfx = 3.5

func _ready():
	get_tree().paused = true

func _process(_delta):
	if waiting.time_left == 0.0:
		get_tree().paused = false
	elif (waiting.time_left <= timeCountdownSfx):
		if !countdown.is_playing():
			countdown.play()
