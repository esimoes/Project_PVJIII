extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_ramp(number):
	if number == 1:
		get_node("one/CollisionBack").disabled = false
		get_node("one/CollisionMiddle").disabled = false
		get_node("one/CollisionFront").disabled = false
		$one.visible = true
	if number == 2:
		get_node("two/CollisionFront").disabled = false
		$two.visible = true
	if number == 3:
		get_node("three/CollisionBack").disabled = false
		get_node("three/CollisionMiddle").disabled = false
		get_node("three/CollisionFront").disabled = false
		$three.visible = true
