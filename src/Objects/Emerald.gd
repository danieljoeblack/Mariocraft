extends KinematicBody2D

export var score = 200

onready var sprite: Sprite = $Sprite

func _ready():
	sprite.offset = Vector2.ZERO

func destroy_self():
	addPointsLabel()
	queue_free()
	
func add_coin():
	PlayerData.coins += 1

func _on_PlayerDetector_body_entered(body: Actor):	
	get_node("AnimationPlayer").play("AppearFromBox")

func addPointsLabel():
	PlayerData.score += score
	var labelObject = load("res://src/Componets/PointLabel.tscn")
	var label = labelObject.instance()
	get_parent().add_child(label)
	label.updateLabel(String(score))
	label.playPointsGot()
	label.global_position = Vector2(global_position.x,global_position.y-25)
