extends KinematicBody2D

export var spawn_object: PackedScene
export var invisible: bool = false
export var hit_bounce_impulse = 350

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = get_node("sprite")
onready var collision: CollisionShape2D = get_node("CollisionShape2D")
onready var destroyDamageArea: Area2D = get_node("DestroyDamageArea")


var been_opened setget set_been_opened

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(invisible):
		sprite.visible = false
		collision.one_way_collision = true
	else:
		collision.one_way_collision = false

func _physics_process(delta):
	if(been_opened && self.collision.one_way_collision):
		self.collision.one_way_collision = false

func _on_Area2D_body_entered(body:KinematicBody2D):
	#calcuate y value based on edge rather then middle, applying global scale
	var actual_y = global_position.y+(get_parent().scale.y*collision.shape.get_extents().y)
	
	#apply bounce to top colliding bodies
	causeDestroyBounce()
	
	#apply damage to colliding bodies when required
	causeDestroyDamage()
	
	#play the animation to jiggle the block
	anim_player.play("Hit")

	#check if actually hit for the body, more for invisible blocks to ensure the
	# player didn't fall through
	if body and body._velocity.y<=100 and !been_opened:
		#flag that the chest has been opened
		self.been_opened = true
		
		#create an instance of our spawn object
		var instance = spawn_object.instance()		
		
		#set the position and direction of the spawn object opposite to the player 
		instance.position.y -= collision.shape.get_extents().y
		instance.position.x += collision.shape.get_extents().x
		if(instance.get("speed")):
			if(body.global_position.x<global_position.x):
				instance.speed.x = -instance.speed.x
			else:
				instance.speed.x = instance.speed.x
		
		#play the animation on the spawn instance
		instance.get_node("AnimationPlayer").play("AppearFromBox")
		
		#add to the scene
		add_child(instance)	

func set_been_opened(value:bool):
	been_opened = value
	sprite.visible = true
	sprite.frame = 1	
	
func causeDestroyDamage():
	var colliding_bodies = destroyDamageArea.get_overlapping_bodies()
	
	for body in colliding_bodies:		
		if(body.get_collision_layer() == 4 and body.get("hitFromBelow") != null):
			body.hitFromBelow = true
			
func causeDestroyBounce():
	var colliding_bodies = destroyDamageArea.get_overlapping_bodies()
	for body in colliding_bodies:
		if(body.get("_velocity") != null):
			body._velocity.y -= hit_bounce_impulse
		
