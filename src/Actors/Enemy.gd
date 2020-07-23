extends Actor

export var physics_enabled = false
export var score: = 100
export var destroy_on_exit = true
export var hp:= 1

var hitFromBelow = false

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var stomp_detector: Area2D = get_node("StompDetector")

func _ready():	
	set_physics_process(physics_enabled)
	_velocity.x = -speed.x	
	
func _on_StompDetector_body_entered(body):
	if(!PlayerData.invincible):
		if body.global_position.y > get_node("StompDetector").global_position.y:
			stomp_detector.monitoring = false
			stomp_detector.monitorable = false
			print("Playering Squinged")
			anim_player.play("Squished")

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
	if(hp <= 0):
		get_node("CollisionShape2D").disabled = true
		stomp_detector.get_node("CollisionShape2D").disabled = true
		die()
	
	if(hitFromBelow):
		get_node("CollisionShape2D").disabled = true
		stomp_detector.get_node("CollisionShape2D").disabled = true
		scale.y = -1
		
		

func _on_VisibilityEnabler2D_screen_entered():
	pass


func _on_VisibilityEnabler2D_screen_exited():
	if(destroy_on_exit):
		queue_free()


func _on_StompDetector_area_entered(area):		
	if area.global_position.y < get_node("StompDetector").global_position.y:				
		get_node("CollisionShape2D").disabled = true
		stomp_detector.monitoring = false
		stomp_detector.monitorable = false
		print("Playering Squinged")
		anim_player.play("Squished")
