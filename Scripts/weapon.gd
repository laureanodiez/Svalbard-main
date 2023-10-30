extends Node3D

@onready var aimcast := $AimCast
@onready var timer : Timer = $reloadTimer

var attack : Attack
@export var MAX_AMMO : int
@export var MAX_MAG : int
var total_ammo : int
var ammo_in_mag : int

@export var reload_time : float = 3.0
var is_reloading : bool = false

@export var weapon_seleceted : bool
@export var weapon_damage : float
@export var stun_time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	attack = Attack.new()
	attack.attack_damage = weapon_damage
	attack.stun_time = stun_time
	
	ammo_in_mag = MAX_MAG
	total_ammo = MAX_AMMO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("change_weapon"):
			change_weapon()
	if weapon_seleceted:
		if Input.is_action_just_pressed("fire") && !is_reloading:
			if ammo_in_mag>0:
				ammo_in_mag -= 1
				if aimcast.is_colliding():
					var target = aimcast.get_collider()
					if target is HitboxComponent:
						target.damage(attack)
						
		elif Input.is_action_just_pressed("reload"):
			reload()

func reload():
	print("reloading")
	is_reloading = true
	timer.start(reload_time)

func change_weapon():
	weapon_seleceted = not weapon_seleceted
	visible = not visible


func _on_reload_timer_timeout():
	print("finished reloading")
	is_reloading = false
	total_ammo -= (MAX_MAG - ammo_in_mag)
	ammo_in_mag = MAX_MAG
