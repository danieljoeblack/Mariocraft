extends Node2D

export var teleportLocation : Vector2 = Vector2.ZERO
export var requiredInput: String
export var bodyAnimation: String
export var secondaryBodyAnimation: String
export var overideBounds = []
export var forceXOverride = true

onready var playerCollider: Area2D = $Area2D

func _physics_process(delta):
	if( (!requiredInput or Input.get_action_strength(requiredInput)) and playerCollider.get_overlapping_bodies().size()>0):
		PlayerData.teleportAnimation = bodyAnimation
		PlayerData.teleportLocation = teleportLocation		
		PlayerData.secondaryTeleportAnimation = secondaryBodyAnimation		
		if(overideBounds != [0,0,0,0]):			
			PlayerData.cameraBounds = overideBounds
		
		if(forceXOverride):
			PlayerData.cameraBoundsOveridden = true
		else:
			PlayerData.cameraBoundsOveridden = false
