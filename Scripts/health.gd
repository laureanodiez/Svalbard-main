extends Node3D
class_name HealthComponent

@export var MAX_HEALTH : float
var health : float

signal health_changed(old_value : float, new_value : float)
signal health_depleted
signal is_stunned(time : float)

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func damage(attack : Attack):
	health -= attack.attack_damage
	is_stunned.emit(attack.stun_time)
	health = clamp(health, 0.0, MAX_HEALTH)

	if health==0.0:
		health_depleted.emit()

func add_health(value : float):
	var old_health = health
	health += value
	clamp(health, 0.0, MAX_HEALTH)
	
	health_changed.emit(old_health, health)
