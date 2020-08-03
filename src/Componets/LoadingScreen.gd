extends Node2D

onready var wordLevelLabel: Label = $CanvasLayer/Control/WorldLevelLabel
onready var livesLabel: Label = $CanvasLayer/Control/Lives

func _ready():
	PlayerData.playerPaused = true
	wordLevelLabel.text = String(PlayerData.current_world)+"-"+String(PlayerData.current_level)
	livesLabel.text = String(PlayerData.lives)

func endLoading():
	PlayerData.playerPaused = false
