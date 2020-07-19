extends KinematicBody2D

export var spawn_object: PackedScene
export var invisible: bool = false

onready var sprite: Sprite = get_node("chest")
onready var collision: CollisionShape2D = get_node("CollisionShape2D")


var been_opened setget set_been_opened

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(invisible):
		sprite.visible = false
		collision.one_way_collision = true
	else:
		collision.one_way_collision = false

func _physics_process(delta):
	if(been_opened && self.collision.one_way_collision):
		self.collision.one_way_collision = false

func _on_Area2D_body_entered(body:KinematicBody2D):
	var actual_y = global_position.y+(get_parent().scale.y*collision.shape.get_extents().y)
		
	if body and body._velocity.y<=0 and !been_opened:
		var instance = spawn_object.instance()
		self.been_opened = true
		
		instance.get_node("AnimationPlayer").play("AppearFromBox")
		
		if(instance.get("speed")):
			if(body.global_position.x<global_position.x):
				instance.speed.x = -instance.speed.x
			else:
				instance.speed.x = instance.speed.x
		instance.position.y -= collision.shape.get_extents().y
		instance.position.x += collision.shape.get_extents().x
		
		add_child(instance)	

func set_been_opened(value:bool):
	been_opened = value
	sprite.visible = true
	sprite.frame = 1	
	
