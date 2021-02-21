extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal replace_main_scene
signal quit

onready var ui = $UI
onready var main = ui.get_node(@"main")
onready var play_button = main.get_node(@"Play")
onready var settings_menu = ui.get_node(@"settings")
onready var settings_config = settings_menu.get_node(@"config")
onready var settings_action_cancel = settings_config.get_node(@"accions/cancel")

onready var resolution_menu = settings_config .get_node(@"resolution")
onready var resolution_1080 = resolution_menu.get_node(@"1080")
onready var resolution_720 = resolution_menu.get_node(@"720")
onready var resolution_540 = resolution_menu.get_node(@"540")

onready var fullscreen_menu = settings_config.get_node(@"fullscreen")
onready var fullscreen_yes = fullscreen_menu.get_node(@"yes")
onready var fullscreen_no = fullscreen_menu.get_node(@"no")

onready var sfxVolume = settings_config.get_node("sfxVolume")
onready var sfxVolume_slider = sfxVolume.get_node("SfxSlider")

onready var MusicVolume = settings_config.get_node("musicVolume")
onready var MusicVolume_slider = MusicVolume.get_node("MusicSlider")

onready var sfx = ui.get_node("sfx")
onready var sfx_accept = sfx.get_node("select")
onready var sfx_cancel = sfx.get_node("cancel")
onready var sfx_music = sfx.get_node("music")


# Called when the node enters the scene tree for the first time.
func _ready():
	sfx_music.play()
	play_button.grab_focus()


func _on_Play_pressed():
	sfx_accept.play()
	main.hide()
	var path = "res://game/Game3D.tscn"
	emit_signal("replace_main_scene", ResourceLoader.load(path))

func _on_Quit_pressed():
	sfx_cancel.play()
	get_tree().quit()

func _on_Option_pressed():
	sfx_accept.play()
	main.hide()
	settings_menu.show()
	settings_action_cancel.grab_focus()
	if Settings.resolution == Settings.Resolution.RES_1080:
		resolution_1080.pressed = true
	elif Settings.resolution == Settings.Resolution.RES_720:
		resolution_720.pressed = true
	elif Settings.resolution == Settings.Resolution.RES_540:
		resolution_540.pressed = true
	
	if Settings.fullscreen:
		fullscreen_yes.pressed = true
	else:
		fullscreen_no.pressed = true
	
	sfxVolume_slider.value = Settings.sfxVol
	MusicVolume_slider.value = Settings.MusicVol
	

func _on_cancel_pressed():
	sfx_cancel.play()
	main.show()
	play_button.grab_focus()
	settings_menu.hide()

func _on_apply_pressed():
	sfx_accept.play()
	main.show()
	play_button.grab_focus()
	settings_menu.hide()
	
	Settings.fullscreen = fullscreen_yes.pressed
	OS.window_fullscreen = Settings.fullscreen
	
	if resolution_1080.pressed:
		Settings.resolution = Settings.Resolution.RES_1080
		OS.set_window_size(Vector2(1920,1080))
	elif resolution_720.pressed:
		Settings.resolution = Settings.Resolution.RES_720
		OS.set_window_size(Vector2(1280,720))
	elif resolution_540.pressed:
		Settings.resolution = Settings.Resolution.RES_540
		OS.set_window_size(Vector2(960,540))
		
	Settings.sfxVol = sfxVolume_slider.value
	Settings.MusicVol = MusicVolume_slider.value
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),Settings.MusicVol)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),Settings.sfxVol)
	
	Settings.save_settings()
