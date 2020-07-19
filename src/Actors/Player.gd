extends Actor

#scene vars
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var grow_timer: Timer = get_node("GrowTimer")
onready var camera: Camera2D = get_node("Camera2D")
onready var barrierCollision: Area2D = get_node("BarrierCollision")
onready var cameraCollision: Area2D = get_node("CameraDetector")
onready var upray: RayCast2D = get_node("RayCast2D")

onready var bigEnemyDetector: Area2D = get_node("BigEnemyDetector")
onready var smallEnemyDetector: Area2D = get_node("EnemyDetector")
onready var bigBarrierDetector: Area2D = get_node("BigBarrierCollision")
onready var smallBarrierDetector: Area2D = get_node("BarrierCollision")

#instance vars
export var stomp_impulse = 300
export var friction = 50
export var max_speed = 200
export var max_run_speed = 250
export var run_speedboost = 50
export var start_hp = 1
export var physics_paused = false
export var allow_backwards_progression = false
export var can_crawl = false

var has_hp=true

		
func _on_Area2D_area_entered(area):		
	if(area.collision_layer == 32):
		_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

#player hit event
func _on_EnemyDetector_body_entered(body):	
	if(body.collision_layer == 4):
		PlayerData.hp -= 1

#player death event
func _on_PlayerData_player_died():
	die()

#Player overlap porkchop powerup
func _on_PlayerData_player_porkchop():	
	#power up if required
	if(PlayerData.pu_state == PlayerData.POWERUP_STATE.BASE):
		PlayerData.hp = 2
		get_tree().paused = true
		physics_paused = true	
		animation_player.play("grow")
		grow_timer.start()

#on ready event
func _ready():	
	PlayerData.connect("player_died",self,"_on_PlayerData_player_died")
	PlayerData.connect("player_porkchop",self,"_on_PlayerData_player_porkchop")
	PlayerData.hp = start_hp
	animation_player.play("stand_right")

#physics loop
func _physics_process(delta: float) -> void:	
	if !physics_paused:
		
		if(PlayerData.pu_state == PlayerData.POWERUP_STATE.BASE):
			set_small_physics()
		else:
			set_big_physics()
		
		var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
		var direction : = get_direction()
		
		if(!allow_backwards_progression):
			update_camera_bound()
		
		#X animations		
		if((PlayerData.pu_state == PlayerData.POWERUP_STATE.BASE or !Input.get_action_strength("crouch")) and !(PlayerData.pu_state != PlayerData.POWERUP_STATE.BASE and upray.is_colliding())):
			if(_velocity.x!=0):
				if(direction.x >= 0 and _velocity.x >0):
					walk_right()				
				elif(direction.x >0):
					turn_right()
				else:
					if(direction.x <= 0 and _velocity.x < 0):
						walk_left()
					else:
						turn_left()
			else:
				stand_still()
		else:
			set_small_physics()
			animation_player.play("Crouch_Big")
	
		#Y animations
		if(_velocity.y<0 or !is_on_floor()):
			if PlayerData.hp <= 1:
				animation_player.play("Jump")
			elif(PlayerData.hp == 2):
				animation_player.play("Jump Big")
			
		_velocity = calculate_move_velocity(_velocity,direction,speed,is_jump_interrupted)
		_velocity = move_and_slide(_velocity,FLOOR_NORMAL)

#get input direction
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction:Vector2,
		speed:Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity	

	#out.x = speed.x*direction.x
	
	var cur_max_speed = 0
	if(Input.get_action_strength("run")):
		cur_max_speed = max_run_speed
	else:
		cur_max_speed = max_speed
	
	if((direction.x != 0 and out.x>(-1*cur_max_speed) and out.x<(cur_max_speed)) and !(!can_crawl and Input.get_action_strength("crouch"))):		
		out.x += speed.x * direction.x * get_physics_process_delta_time()
		if(Input.get_action_strength("run")):
			out.x+= run_speedboost*direction.x* get_physics_process_delta_time()
		if(direction.x > 0 and out.x<0):
			out.x += friction*get_physics_process_delta_time()
		if(direction.x < 0 and out.x>0):
			out.x -= friction*get_physics_process_delta_time()
	else:
		if (out.x>(-1*friction* get_physics_process_delta_time()) and out.x<(friction* get_physics_process_delta_time())) :
			out.x=0
		else:
			if out.x>0: out.x -= friction* get_physics_process_delta_time()
			elif out.x<0: out.x+= friction* get_physics_process_delta_time()
				

	if(!allow_backwards_progression):
		var bound_passed = camera.limit_left >= (position.x-barrierCollision.shape.get_extents().x)*get_parent().scale.x
		var moving_left = _velocity.x < 0 or direction.x < 0
		
		if	bound_passed and moving_left:		
			out.x=0

	
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out

func turn_left():
	if(PlayerData.pu_state <=PlayerData.POWERUP_STATE.BASE):
		animation_player.play("Turn Left")
	elif PlayerData.pu_state <=PlayerData.POWERUP_STATE.GROWN:
		animation_player.play("Turn Left Big")

func turn_right():
	if(PlayerData.pu_state <=PlayerData.POWERUP_STATE.BASE):
		animation_player.play("Turn Right")
	elif(PlayerData.pu_state <=PlayerData.POWERUP_STATE.GROWN):
		animation_player.play("Turn Right Big")

func walk_right():
	if(PlayerData.pu_state <=PlayerData.POWERUP_STATE.BASE):
		if animation_player.current_animation != "Walk Right":
			animation_player.play("Walk Right")
	elif(PlayerData.pu_state <=PlayerData.POWERUP_STATE.GROWN):
		if animation_player.current_animation != "Walk Right Big":
			animation_player.play("Walk Right Big")
	
func walk_left():
	if(PlayerData.pu_state <=PlayerData.POWERUP_STATE.BASE):
		if animation_player.current_animation != "Walk Left":
			animation_player.play("Walk Left")
	elif(PlayerData.pu_state <=PlayerData.POWERUP_STATE.GROWN):
		if animation_player.current_animation != "Walk Left Big":
			animation_player.play("Walk Left Big")

func stand_still():
	if(PlayerData.pu_state <=PlayerData.POWERUP_STATE.BASE):
		animation_player.play("stand_right")
	elif(PlayerData.pu_state <=PlayerData.POWERUP_STATE.GROWN):
		animation_player.play("stand_right_big")

func die()->void:	
	queue_free()

func _on_GrowTimer_timeout():	
	physics_paused = false
	get_tree().paused = false
	
func update_camera_bound():	
	var cur_left_cam_bound = floor(camera.get_camera_position().x-(camera.get_viewport().size.x*camera.zoom.x)/2)	
	if(cur_left_cam_bound>camera.limit_left):
		camera.limit_left = cur_left_cam_bound	
		
func set_small_physics():
	bigEnemyDetector.monitoring = false
	bigEnemyDetector.monitorable = false
	bigBarrierDetector.disabled = true
	
	smallEnemyDetector.monitorable=true
	smallEnemyDetector.monitoring=true
	smallBarrierDetector.disabled = false
	
func set_big_physics():
	smallEnemyDetector.monitoring = false
	smallEnemyDetector.monitorable = false
	smallBarrierDetector.disabled = true
	
	bigEnemyDetector.monitorable=true
	bigEnemyDetector.monitoring=true
	bigBarrierDetector.disabled = false
	
func set_hp(hp_modifier):
	PlayerData.hp += hp_modifier



