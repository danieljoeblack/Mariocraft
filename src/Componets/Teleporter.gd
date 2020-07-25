extends Node2D

export var teleportLocation : Vector2 = Vector2.ZERO
export var requiredInput: String
export var overideBounds = []

onready var playerCollider: Area2D = $Area2D

func _physics_process(delta):
	if( (!requiredInput or Input.get_action_strength(requiredInput)) and playerCollider.get_overlapping_bodies().size()>0):
		PlayerData.teleportLocation = teleportLocation
		if(overideBounds != [0,0,0,0]):
			PlayerData.cameraBoundsOveridden = true
			PlayerData.cameraBounds = overideBounds
		else:
			PlayerData.cameraBoundsOveridden = false
