extends Node2D

onready var firstButton: Button = $CanvasLayer/VBoxContainer/OptionButton2

func _ready():
	if(firstButton):
		firstButton.grab_focus()
