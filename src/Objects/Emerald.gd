extends KinematicBody2D

export var score = 100

onready var sprite: Sprite = $Sprite

func _ready():
	sprite.offset = Vector2.ZERO

func destroy_self():
	queue_free()


func _on_PlayerDetector_body_entered(body: Actor):	
	get_node("AnimationPlayer").play("AppearFromBox")
