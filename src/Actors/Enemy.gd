extends Actor

export var physics_enabled = false
export var score: = 100
export var destroy_on_exit = true
export var hp:= 1

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var stomp_detector: Area2D = get_node("StompDetector")

func _ready():	
	set_physics_process(physics_enabled)
	_velocity.x = -speed.x	
	
func _on_StompDetector_body_entered(body):
	if(!PlayerData.invincible):
		if body.global_position.y > get_node("StompDetector").global_position.y:		
			self.hp -= 1

func _physics_process(delta):	
	checkDeath()
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	if(!anim_player.current_animation == "Walking"):		
		anim_player.play("Walking")	
	
func die()->void:		
	get_node("CollisionShape2D").queue_free()	
	get_node("StompDetector").queue_free()
	get_node("enemy").queue_free()
	queue_free()

func checkDeath():
	if(hp <= 0):		
		get_node("CollisionShape2D").disabled = true
		die()

func _on_VisibilityEnabler2D_screen_entered():
	pass


func _on_VisibilityEnabler2D_screen_exited():
	if(destroy_on_exit):
		queue_free()


func _on_StompDetector_area_entered(area):		
	if area.global_position.y < get_node("StompDetector").global_position.y:		
		
		get_node("CollisionShape2D").disabled = true
		die()
