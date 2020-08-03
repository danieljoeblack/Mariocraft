extends Node

signal player_died
signal player_porkchop
signal player_apple
signal player_damaged
signal teleporting_player

onready var timeLimitTimer: Timer = $TimeLimit

export var _velocity = Vector2(Vector2.ZERO)
export var invincible = false

export var current_level = 1
export var current_world = 1
export var lives = 2 setget set_lives
export var score = 0
export var characterName = "Mario"
export var timeLimitReached = false
export var coins = 0
export var timeLimit = 300

var hp = 1 setget set_hp
var teleportLocation: Vector2 = Vector2.ZERO setget set_teleport_location
var teleportAnimation: String 
var secondaryTeleportAnimation: String 
var cameraBoundsOveridden = false
var cameraBounds = [0,0,0,0]
var playerPaused = false
var pointAmount = 0 setget setPointAmount

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
	
func golden_apple_picked_up():
	emit_signal("player_apple")

func set_hp(value:int)->void:
	var hit = value<hp
	var dead = value <= 0

	if((hit and !invincible) or !hit):		
		hp = value
	
	if(hit and !dead and !invincible):
		emit_signal("player_damaged")
	
	if(pu_state != POWERUP_STATE.INVINCIBLE):
		if(hp<=0):			
			emit_signal("player_died")
		elif hp == 1:
			pu_state = POWERUP_STATE.BASE
		elif hp == 2:
			pu_state = POWERUP_STATE.GROWN

func set_teleport_location(value):
	if(teleportLocation != value):
		teleportLocation = value	
		emit_signal("teleporting_player")

func getBaseState():	
	if hp == 1:
		return POWERUP_STATE.BASE
	elif hp == 2:
		return POWERUP_STATE.GROWN

func set_lives(value):
	if(value<lives):
		lives = value
		if(lives>=0):
			get_tree().reload_current_scene()
		else:
			score = 0
			pointAmount = 0
			coins = 0
			lives = 3
			get_tree().change_scene("res://src/Componets/GameOverScreen.tscn")
	else:
		lives = value

#timeout logic
func _on_TimeLimit_timeout():
	timeLimitReached = true

func setTimerRunning(value):
	if(timeLimitTimer.paused != value):
		timeLimitTimer.paused = value	

func resetTimer(time):
	timeLimitTimer.stop()	
	timeLimitTimer.wait_time = time
	timeLimitTimer.start()
	
func setPointAmount(value):
	score += value
	pointAmount = value
	
