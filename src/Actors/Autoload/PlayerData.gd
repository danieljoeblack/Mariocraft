extends Node

signal player_died
signal player_porkchop

export var _velocity = Vector2(Vector2.ZERO)

var hp = 1 setget set_hp
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
	print("Set HP:",value)
	var hit = value<hp
	
	hp = value
	if(hp<=0):	
		emit_signal("player_died")
	elif hp == 1:
		pu_state = POWERUP_STATE.BASE
	elif hp == 2:
		pu_state = POWERUP_STATE.GROWN	
