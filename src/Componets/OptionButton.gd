extends Button

export var sceneChange = ""

onready var iconSprite: TextureRect = $TextureRect


func _ready():
	iconSprite.visible = false
	
func _on_Button_focus_entered():
	print("fired")
	iconSprite.visible = true

func _on_Button_focus_exited():
	iconSprite.visible = false


func _on_Button_pressed():
	get_tree().change_scene(sceneChange)
