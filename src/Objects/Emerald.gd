extends KinematicBody2D

export var score = 100

func destroy_self():
	queue_free()
