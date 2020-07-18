extends StaticBody2D

onready var particleAnimation: CPUParticles2D = $CPUParticles2D
onready var borderCollisions: CollisionShape2D = $BorderCollision
onready var sprite: Sprite = $"dirt clone-1png (1)"
onready var destroyTimer: Timer = $DestroyTimer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayerCollision_body_entered(body):
	if(PlayerData.pu_state != PlayerData.POWERUP_STATE.BASE):
		particleAnimation.emitting = true
		sprite.visible = false
		borderCollisions.disabled = true
		destroyTimer.start()

func _on_DestroyTimer_timeout():
	queue_free()
