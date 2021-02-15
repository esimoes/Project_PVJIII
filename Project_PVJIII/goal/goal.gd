extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lap = 0
var totalLaps = 0

const FINISH = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_lap(number):
	lap = number
	get_node("StaticBody/TextSprite").frame = lap - 1
	
func set_total_laps(number):
	totalLaps = number
	get_node("StaticBody/TextSprite").frame = FINISH
	
func get_lap():
	return lap


func _on_goalArea_body_entered(body):
	if (body.get_class()=="VehicleBody"):
		body.set_goalReach(lap)
		if lap == totalLaps:
			body.set_finish()
	#get_node("goalArea").monitoring = false

