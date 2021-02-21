extends VehicleBody

onready var sfx = $sfx
onready var sfx_average = sfx.get_node(@"average")
onready var sfx_fast = sfx.get_node(@"fast")
onready var sfx_alarm = sfx.get_node(@"alarm")

onready var rear_wheel = get_node("WheelRear")
onready var front_wheel = get_node("WheelFront")

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
var speedLimit = 0.0
var temp
var onGrass = false
var overHeat = false
var coolingTime = 0
var lapsReach = []
var timeGame = 0
var finish = false
var begin = false

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
	if !finish && begin:
		timeGame += _delta
	else:
		rear_wheel.engine_force = engine_force_value
		front_wheel.engine_force = engine_force_value * .2
		speedLimit = MAX_SPEED
			
	steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	steer_target *= STEER_LIMIT
	if Input.is_action_pressed("turbo") && !overHeat:
	
		rear_wheel.engine_force = engine_force_value * 1.5
		front_wheel.engine_force = engine_force_value * .8
		speedLimit = TURBO_SPEED
		temp += TempStepTurbo * _delta
	else:
		if Input.is_action_pressed("accelerate") && !overHeat:
			rear_wheel.engine_force = engine_force_value
			front_wheel.engine_force = engine_force_value * .2
			speedLimit = MAX_SPEED
			if temp <= (TEMP_MAX / 2.0):
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
			speedLimit = TURBO_SPEED / 2.0
		else:
			speedLimit = MAX_SPEED / 2.0
	
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
			
	sfx_control()

func get_traveled_distance():
	return traveled

func get_temperature():
	return temp

func get_overheat():
	return overHeat

func set_onGrass():
	onGrass = true

func set_outGrass():
	onGrass = false

func set_zero_force(): 
	rear_wheel.engine_force = 0
	front_wheel.engine_force = 0
	engine_force = 0

func set_finish():
	finish = true

func set_goalReach(lap):
	lapsReach.append(Vector2(lap,timeGame))
	#print (lapsReach)

func get_time():
	return timeGame
	
func sfx_control():
	if rear_wheel.engine_force == 0:
		sfx_average.volume_db = -8
		sfx_fast.stop()
	elif rear_wheel.engine_force > engine_force_value:
		if !sfx_fast.is_playing():
			sfx_fast.play()
	elif rear_wheel.engine_force > 0:
		sfx_average.volume_db = 0
		sfx_fast.stop()
		sfx_average.play()
	
	if temp >= TEMP_MAX / 1.10:
		if !sfx_alarm.is_playing():
			sfx_alarm.play()
		if temp >= TEMP_MAX:
			sfx_average.stop()
	else:
		sfx_alarm.stop()
	
func _on_waitng_timeout():
	begin = true

