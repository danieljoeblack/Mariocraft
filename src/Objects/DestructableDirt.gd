extends StaticBody2D

onready var particleAnimation: CPUParticles2D = $CPUParticles2D
onready var borderCollisions: CollisionShape2D = $BorderCollision
onready var sprite: Sprite = $sprite
onready var destroyTimer: Timer = $DestroyTimer
onready var destroyDamageArea: Area2D = $DestroyDamageArea
onready var anim_player: AnimationPlayer = $AnimationPlayer

export var hit_bounce_impulse = 350
export var spawn_object: PackedScene
export var object_amount = 0

func _on_PlayerCollision_body_entered(body):
	anim_player.play("Hit")
	if(object_amount <= 0):
		causeDestroyDamage()
		if(PlayerData.pu_state != PlayerData.POWERUP_STATE.BASE):
			particleAnimation.emitting = true
			sprite.visible = false
			borderCollisions.disabled = true
			destroyTimer.start()
	else:
		#create an instance of our spawn object
		var instance = spawn_object.instance()		
		
		#set the position and direction of the spawn object opposite to the player 
		#instance.position.y -= borderCollisions.shape.get_extents().y
		#instance.position.x += borderCollisions.shape.get_extents().x
		if(instance.get("speed")):
			if(body.global_position.x<global_position.x):
				instance.speed.x = -instance.speed.x
			else:
				instance.speed.x = instance.speed.x
		
		#play the animation on the spawn instance
		instance.get_node("AnimationPlayer").play("AppearFromBox")
		
		#add to the scene
		add_child(instance)
		object_amount -= 1

func _on_DestroyTimer_timeout():
	queue_free()

func causeDestroyDamage():
	var colliding_bodies = destroyDamageArea.get_overlapping_bodies()
	
	for body in colliding_bodies:		
		if(body.get_collision_layer() == 4 and body.get("hitFromBelow") != null):
			body.hitFromBelow = true
		if(body.get("_velocity") != null):
			body._velocity.y -= hit_bounce_impulse
