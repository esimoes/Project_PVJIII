extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("traveled").text = "Traveled: " + str(int(get_parent().get_node("Bike").get_traveled_distance())) + "m"
	get_node("bikeRecord/time").text = str(format_time(get_parent().get_record_time()))
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_node("traveled").text = "Traveled: " + str(int(get_parent().get_node("Bike").get_traveled_distance())) + "m"
	get_node("traveled").text += " V: " + str(abs(int(get_parent().get_node("Bike").linear_velocity.x))) + "km/h"
	get_node("bikeClock/time").text = str(format_time(get_parent().get_node("Bike").get_time()))
#	pass



func format_time(_time):
	var digits = []
	var minutes = "%02d" % [_time / 60]
	digits.append(minutes)
	var seconds = "%02d" % [int(_time)%60]
	digits.append(seconds)
	var miliseg = "%02d" % [(_time-int(_time))*100]
	digits.append(miliseg)
	var formatted = String()
	var colon = " : "
	for digit in digits:
		formatted += digit + colon
	if not formatted.empty():
		formatted = formatted.rstrip(colon)
	return formatted
