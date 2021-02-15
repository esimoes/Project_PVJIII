extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var ui = $UI
onready var main = ui.get_node(@"Main")
onready var play_button = main.get_node(@"Play")
#onready var settings_button = main.get_node(@"Settings")
#onready var quit_button = main.get_node(@"Quit")

signal replace_main_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	main.hide()
	#loading.show()
	var path = "res://game/Game3D.tscn"
	#if ResourceLoader.has_cached(path):
	emit_signal("replace_main_scene", ResourceLoader.load(path))
	#else:
		#res_loader = ResourceLoader.load_interactive(path)
		#loading_thread = Thread.new()
		#warning-ignore:return_value_discarded
		#loading_thread.start(self, "interactive_load", res_loader)


