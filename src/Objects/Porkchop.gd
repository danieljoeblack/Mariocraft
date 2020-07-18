extends Area2D

func _on_Porkchop_body_entered(body):
	PlayerData.porkchop_picked_up()
	queue_free()
