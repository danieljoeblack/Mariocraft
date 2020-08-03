extends Node2D

export var pointAmount = "100"

onready var label: Label = $Label
onready var anim_player = $AnimationPlayer

func _ready():
	label.text = pointAmount

func updateLabel(text):
	if(label):
		label.text = text

func playPointsGot():
	anim_player.play("points_got")
