extends KinematicBody2D

export var spawn_object: PackedScene

onready var sprite: Sprite = get_node("chest")
onready var collision: CollisionShape2D = get_node("CollisionShape2D")


var been_opened setget set_been_opened

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):	
	if body.global_position.x>global_position.x and !been_opened:
		var instance = spawn_object.instance()
		self.been_opened = true
		instance.get_node("AnimationPlayer").play("AppearFromBox")
		
		instance.position.y -= collision.shape.get_extents().y
		instance.position.x += collision.shape.get_extents().x				
		
		add_child(instance)

func set_been_opened(value:bool):
	been_opened = value
	sprite.frame = 1
	
