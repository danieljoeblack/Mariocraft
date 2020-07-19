extends Actor

onready var visibility_notifier: VisibilityNotifier2D = get_node("VisibilityNotifier2D")

export var enable_physics = false
export var destroy_on_exit = true

func _ready():	
	_velocity.x = -speed.x

func _physics_process(delta):	
	if(enable_physics):
		_velocity.y += gravity * delta
		if is_on_wall():
			_velocity.x *= -1.0	
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func _on_Area2D_body_entered(body):
	if(enable_physics):
		PlayerData.porkchop_picked_up()
		queue_free()

func enable_physics():
	if(destroy_on_exit):
		enable_physics = true


func _on_VisibilityNotifier2D_screen_exited():
	print("Porkchop gone :(")	
	queue_free()
