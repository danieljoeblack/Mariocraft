extends StaticBody2D

export var instakill = false

onready var damage_detector: Area2D = $DamageDetector
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):	
	if(damage_detector.get_overlapping_bodies().size()>0):
		_on_DamageDetector_body_entered(damage_detector.get_overlapping_bodies()[0])

func _on_DamageDetector_body_entered(body):	
	if(body.get("hp") || body.get("has_hp")):
		if(instakill):
			body.set_hp(-1000)
		else:
			body.set_hp(-1)
