extends CharacterBody3D

@export var SPEED : float = 2
var speed : float
var direction : Vector3 = Vector3.ZERO
var gridPosition : Vector3i

var stunned : bool = false
@onready var stunTimer : Timer = $stunTimer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var camaraSens : float = .5
#@onready var camera = get_node("Camera3D") 
@onready var head = $Head

var mouseDelta : Vector2 = Vector2()


signal gridPositionChanged(old_pos, new_pos)
signal globalPositionChanged(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	speed = SPEED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * camaraSens))
		head.rotate_x(deg_to_rad(event.relative.y * camaraSens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func translateCoordinates(pos : Vector3) -> Vector3i:
	return Vector3i(floor(pos.x/10)*10 + 5, 0, floor(pos.z/10)*10 + 5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	globalPositionChanged.emit(position)
	
	var oldPosition : Vector3i
	oldPosition = gridPosition
	
	gridPosition = translateCoordinates(position)
	if gridPosition != oldPosition:
		gridPositionChanged.emit(oldPosition, gridPosition)
		oldPosition = gridPosition
		
func _physics_process(delta):
	if !stunned:
		
		var inputDirection = getInput()
		direction = lerp(direction, (transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized(), delta*10)
		
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
		
#	velocity.y += -gravity*delta
	move_and_slide()
	
func getInput():
	var inputDirection = Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	return inputDirection.normalized()
	
#func setCameraRotation(delta):
#	camera.rotation_degrees -= Vector3 (rad_to_deg(mouseDelta.y),0,0) * camaraSens * delta
#
#	camera.rotation_degrees -= Vector3 (0,rad_to_deg(mouseDelta.x),0) * camaraSens * delta
#
#	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
#	if abs(camera.rotation_degrees.y) >= 360:
#		camera.rotation_degrees.y = 0
#
#	mouseDelta = Vector2()

#func getCameraDirection(i:int):
#	if i==0:
#		return Vector3(0, 0, 1)
#	if i==1:
#		return Vector3(1, 0, 0)
#	if i==2:
#		return Vector3(-1, 0, 0)
#	if i==3:
#		return Vector3(0, 0, -1)


func _on_health_health_depleted():
	# do death stuff
	queue_free()


func _on_health_is_stunned(time):
	if time==0:
		return
	
	if !stunned:
		stunTimer.start(time)
	stunned = true


func _on_stun_timer_timeout():
	stunned = false
