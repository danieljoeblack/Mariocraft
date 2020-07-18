extends Actor

export var physics_enabled = false
export var score: = 100

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var stomp_detector: Area2D = get_node("StompDetector")

func _ready():	
	set_physics_process(physics_enabled)
	_velocity.x = -speed.x
	anim_player.play("Walking")
	
func _on_StompDetector_body_entered(body):
	print("STOMPED")	
	if body.global_position.y > get_node("StompDetector").global_position.y:		
		get_node("CollisionShape2D").disabled = true
		die()

func _physics_process(delta):
	if(true):
		_velocity.y += gravity * delta
		if is_on_wall():
			_velocity.x *= -1.0
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
func die()->void:		
	get_node("CollisionShape2D").queue_free()	
	get_node("StompDetector").queue_free()
	get_node("enemy").queue_free()
	queue_free()


func _on_VisibilityEnabler2D_screen_entered():
	print("Zomb suprise")


func _on_VisibilityEnabler2D_screen_exited():
	print("Zomb gone")


func _on_StompDetector_area_entered(area):		
	if area.global_position.y < get_node("StompDetector").global_position.y:		
		get_node("CollisionShape2D").disabled = true
		die()
