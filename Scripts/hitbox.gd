extends Area3D
class_name HitboxComponent

@export var health : HealthComponent
@export var damageMultiplier : float = 1.0

func damage(attack : Attack):
	if health:
		var myAttack = Attack.new()
		myAttack.attack_damage = attack.attack_damage * damageMultiplier
		myAttack.stun_time = attack.stun_time
		health.damage(myAttack)

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
