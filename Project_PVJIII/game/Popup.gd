extends Container


signal quit
signal replace_main_scene

onready var world = get_parent().get_parent()
onready var pause = get_node("pause")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(_delta):
	if !pause.visible:
		if visible :
			var showMsj = world.get_win()
			if showMsj:
				get_node("winTexture").visible = true
			else:
				get_node("loseTexture").visible = true
#	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if (Input.MOUSE_MODE_HIDDEN):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		show_popup()
		get_tree().paused = !get_tree().paused

func _on_rebootButton_pressed():
	get_tree().paused = false
	var path = "res://game/Game3D.tscn"
	emit_signal("replace_main_scene", ResourceLoader.load(path))

func _on_Button_pressed():
	get_tree().paused = false
	emit_signal("quit")

func show_popup():
	pause.visible = !pause.visible
	visible = !visible

