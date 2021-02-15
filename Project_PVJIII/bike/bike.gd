extends VehicleBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MAX_SPEED = -15 #m/s = 200 kph
const TURBO_SPEED = -30
const HEAT_SPEED = -5 
const TEMP_MAX = 100 #grados C
const TEMP_INI = 20
const COOLING_WAIT = 5

const STEER_SPEED = 2
const STEER_LIMIT = 0.4 # radians = 23 degrees 

var steer_target = 0
var traveled = 0
var inicial = 0
var speedLimit = 0
var temp
var onGrass = false
var overHeat = false
var coolingTime = 0
var lapsReach = []
var timeGame = 0
var finish = false

export var engine_force_value = 400
export var TempStepNormal = 3 # temperatura que calienta el motor por segundo
export var TempStepTurbo = 5 # temperatura que calienta el motor por segundo en modo turbo
export var TempCooling = 1.5 # temperatura de enfriamiento

func _ready():
	inicial = translation.x
	temp = TEMP_INI
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	if !finish :
		timeGame += _delta
	else:
		get_node("WheelRear").engine_force = engine_force_value
		get_node("WheelFront").engine_force = engine_force_value * .2
		speedLimit = MAX_SPEED
			
	steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	steer_target *= STEER_LIMIT
	if Input.is_action_pressed("turbo") && !overHeat:
		get_node("WheelRear").engine_force = engine_force_value * 1.5
		get_node("WheelFront").engine_force = engine_force_value * .8
		speedLimit = TURBO_SPEED
		temp += TempStepTurbo * _delta
	else:
		if Input.is_action_pressed("accelerate") && !overHeat:
			get_node("WheelRear").engine_force = engine_force_value
			get_node("WheelFront").engine_force = engine_force_value * .2
			speedLimit = MAX_SPEED
			if temp <= (TEMP_MAX / 2):
				temp += TempStepNormal * _delta
			else:
				temp -= TempCooling * _delta
		else:
			if !finish:
				set_zero_force()
				if temp >=  TEMP_INI:
					temp -= TempCooling * _delta
	
	if temp >= TEMP_MAX:
		temp = TEMP_MAX
		overHeat = true
	
	if Input.is_action_pressed("up"):
		angular_velocity.z = -1
	if Input.is_action_pressed("down"):
		angular_velocity.z = 1
	
	if (onGrass):
		if (speedLimit == TURBO_SPEED):
			speedLimit = TURBO_SPEED / 2
		else:
			speedLimit = MAX_SPEED / 2
	
	if (linear_velocity.x < speedLimit):
		linear_velocity.x = speedLimit
		
	steering = move_toward(steering, steer_target, STEER_SPEED * _delta)
	traveled = abs(translation.x - inicial) 
	
	
	if (overHeat):
		speedLimit = HEAT_SPEED
		coolingTime += _delta
		if (coolingTime >= COOLING_WAIT):
			overHeat = false
			coolingTime = 0


func get_traveled_distance():
	return traveled

func get_temperature():
	return temp

func set_onGrass():
	onGrass = true

func set_outGrass():
	onGrass = false

func set_zero_force(): 
	get_node("WheelRear").engine_force = 0
	get_node("WheelFront").engine_force = 0
	engine_force = 0

func set_finish():
	finish = true

func set_goalReach(lap):
	lapsReach.append(Vector2(lap,timeGame))
	print (lapsReach)

func get_time():
	return timeGame
