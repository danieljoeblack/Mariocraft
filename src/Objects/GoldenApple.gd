extends Actor

onready var visibility_notifier: VisibilityNotifier2D = get_node("VisibilityNotifier2D")

export var enable_physics = false
export var destroy_on_exit = true
export var score = 1000

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
		PlayerData.golden_apple_picked_up()
		addPointsLabel()
		queue_free()

func enable_physics():
	if(destroy_on_exit):
		enable_physics = true
		
func addPointsLabel():
	PlayerData.score += score
	var labelObject = load("res://src/Componets/PointLabel.tscn")
	var label = labelObject.instance()
	
	get_parent().add_child(label)
	label.updateLabel(String(score))
	label.playPointsGot()
	label.global_position = global_position	


func _on_VisibilityNotifier2D_screen_exited():	
	queue_free()
