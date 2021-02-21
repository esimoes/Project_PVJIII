extends Node


enum Sound {
	DISABLED = 0,
	LOW = 1,
	HIGH = 2,
}

enum Resolution {
	RES_540 = 0,
	RES_720 = 1,
	RES_1080 = 2,
	NATIVE = 3,
}

var sfxVol = 0.0
var MusicVol = 0.0
var resolution = Resolution.NATIVE
var fullscreen = false

func _ready():
	load_settings()


func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		get_tree().set_input_as_handled()


func load_settings():
	var f = File.new()
	var error = f.open("res://settings.json", File.READ)
	if error:
		print("There are no settings to load.")
		return
	var d = parse_json(f.get_as_text())
	if typeof(d) != TYPE_DICTIONARY:
		return
	if "resolution" in d:
		resolution = int(d.resolution)
	if "fullscreen" in d:
		fullscreen = bool(d.fullscreen)
	if "sfxVol" in d:
		sfxVol = d.sfxVol
	if "MusicVol" in d:
		MusicVol = d.MusicVol
	load_setting_file()

func save_settings():
	var f = File.new()
	var error = f.open("res://settings.json", File.WRITE)
	assert(not error)

	var d = {"resolution":resolution, "fullscreen":fullscreen, "sfxVol":sfxVol, "MusicVol":MusicVol }
	f.store_line(to_json(d))

func load_setting_file():
	OS.window_fullscreen = Settings.fullscreen
	if Settings.resolution == Settings.Resolution.RES_1080:
		OS.set_window_size(Vector2(1920,1080))
	elif Settings.resolution == Settings.Resolution.RES_720:
		OS.set_window_size(Vector2(1280,720))
	elif Settings.resolution == Settings.Resolution.RES_540:
		OS.set_window_size(Vector2(960,540))
		
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),Settings.MusicVol)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),Settings.sfxVol)
