extends StaticBody2D

onready var particleAnimation: CPUParticles2D = $CPUParticles2D
onready var borderCollisions: CollisionShape2D = $BorderCollision
onready var sprite: Sprite = $sprite
onready var destroyTimer: Timer = $DestroyTimer
onready var destroyDamageArea: Area2D = $DestroyDamageArea
onready var anim_player: AnimationPlayer = $AnimationPlayer

export var hit_bounce_impulse = 350

func _on_PlayerCollision_body_entered(body):
	causeDestroyDamage()
	anim_player.play("Hit")
	if(PlayerData.pu_state != PlayerData.POWERUP_STATE.BASE):		
		particleAnimation.emitting = true
		sprite.visible = false
		borderCollisions.disabled = true
		destroyTimer.start()

func _on_DestroyTimer_timeout():
	queue_free()

func causeDestroyDamage():
	var colliding_bodies = destroyDamageArea.get_overlapping_bodies()
	
	for body in colliding_bodies:		
		if(body.get_collision_layer() == 4 and body.get("hitFromBelow") != null):
			body.hitFromBelow = true
		if(body.get("_velocity") != null):
			body._velocity.y -= hit_bounce_impulse
