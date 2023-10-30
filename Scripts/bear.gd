extends CharacterBody3D

var speed = 2
var accel = 10

var stunned : bool = false
@onready var stunTimer : Timer = $stunTimer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var targetPosition : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().targetPosition.connect(targetPositionUpdate)

func targetPositionUpdate(pos : Vector3):
	targetPosition = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var direction = Vector3.ZERO
	if !stunned:
		
		direction = targetPosition - position

		direction = direction.normalized()
		
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		rotation.y = atan2(velocity.x,velocity.z)
		rotation_degrees.y -= 90
		
#	velocity.y -= gravity*delta
	move_and_slide()

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
