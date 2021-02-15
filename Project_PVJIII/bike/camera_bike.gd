extends Camera


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin

	translation = Vector3(target.x,pos.y,pos.z)


