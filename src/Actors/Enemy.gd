extends Actor

export var physics_enabled = false
export var score: = 100
export var destroy_on_exit = true
export var hp:= 1

var hitFromBelow = false
var dead = false

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var stomp_detector: Area2D = get_node("StompDetector")
onready var player_invincibility_detector: Area2D = get_node("PlayerInvincibilityDeathArea")
onready var deathTimer: Timer = $DeathTimer
onready var sprite: Sprite = $enemy
onready var hitSound: AudioStreamPlayer2D = $HitSound

func _ready():	
	set_physics_process(physics_enabled)
	_velocity.x = -speed.x	

func _physics_process(delta):
	checkDeath()
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	if(!anim_player.is_playing()):		
		anim_player.play("Walking")	
	
func die()->void:
	queue_free()

func damage():
	self.hp -= 1	

func checkDeath():
	if(!dead):
		if(hp == 0):			
			dead = true
			get_node("CollisionShape2D").disabled = true
			stomp_detector.get_node("CollisionShape2D").disabled = true
			player_invincibility_detector.get_node("CollisionShape2D").disabled = true
			sprite.visible = false			
			play_random_hit()
			addPointsLabel()			
			deathTimer.start()
		
		if(hitFromBelow):			
			dead = true
			get_node("CollisionShape2D").disabled = true
			stomp_detector.get_node("CollisionShape2D").disabled = true
			player_invincibility_detector.get_node("CollisionShape2D").disabled = true
			scale.y = -1
			play_random_hit()
			addPointsLabel()
			deathTimer.start()
			
		
		

func _on_VisibilityEnabler2D_screen_entered():
	pass


func _on_VisibilityEnabler2D_screen_exited():
	if(destroy_on_exit):
		queue_free()


func _on_StompDetector_area_entered(area):		
	if area.global_position.y < get_node("StompDetector").global_position.y and !PlayerData.invincible and ! PlayerData.pu_state == PlayerData.POWERUP_STATE.INVINCIBLE:
		get_node("CollisionShape2D").disabled = true
		stomp_detector.monitoring = false
		stomp_detector.monitorable = false		
		anim_player.play("Squished")


func _on_PlayerInvincibilityDeathArea_body_entered(body: Actor):	
	if(body && body.collision_layer == 1 and PlayerData.pu_state == PlayerData.POWERUP_STATE.INVINCIBLE):
		_velocity.y -= 350
		hitFromBelow = true

func addPointsLabel():
	PlayerData.pointAmount += score
	var labelObject = load("res://src/Componets/PointLabel.tscn")
	var label = labelObject.instance()
	get_parent().add_child(label)
	label.updateLabel(String(PlayerData.pointAmount))
	label.playPointsGot()
	label.global_position = global_position	
	
func _on_DeathTimer_timeout():
	die()

func play_random_hit():
	var pitchModifer = rand_range(0.75,1.5)
	hitSound.pitch_scale = pitchModifer	
	hitSound.play()
