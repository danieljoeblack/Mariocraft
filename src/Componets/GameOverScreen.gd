extends Node2D

export var nextScene = ""

func endLoading():
	get_tree().change_scene(nextScene)
