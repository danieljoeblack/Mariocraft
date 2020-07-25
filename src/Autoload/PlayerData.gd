extends Node

signal player_died
signal player_porkchop
signal player_damaged
signal teleporting_player

export var _velocity = Vector2(Vector2.ZERO)
export var invincible = false

var hp = 1 setget set_hp
var teleportLocation: Vector2 = Vector2.ZERO setget set_teleport_location
var cameraBoundsOveridden = false
var cameraBounds = [0,0,0,0]

enum POWERUP_STATE{
	BASE,
	GROWN,
	RANGED,
	INVINCIBLE
}

func _physics_process(delta):
	#testing restart
	if(Input.get_action_strength("restart")):
		get_tree().reload_current_scene()

var pu_state = POWERUP_STATE.BASE

func porkchop_picked_up():	
	emit_signal("player_porkchop")

func set_hp(value:int)->void:
	var hit = value<hp
	var dead = value <= 0

	if((hit and !invincible) or !hit):		
		hp = value
	
	if(hit and !dead and !invincible):
		emit_signal("player_damaged")
	
	if(hp<=0):	
		print(hp)
		emit_signal("player_died")
	elif hp == 1:
		pu_state = POWERUP_STATE.BASE
	elif hp == 2:
		pu_state = POWERUP_STATE.GROWN	

func set_teleport_location(value):
	teleportLocation = value
	print("Emit Signal")
	emit_signal("teleporting_player")
