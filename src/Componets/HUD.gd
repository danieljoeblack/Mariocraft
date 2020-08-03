extends Node2D

onready var characterNameLabel: Label = $CanvasLayer/Control/CharacterNameLabel
onready var scoreLabel: Label = $CanvasLayer/Control/ScoreLabel
onready var coinsLabel: Label = $CanvasLayer/Control/CoinsLabel
onready var worldLevelLabel: Label = $CanvasLayer/Control/WorldLevelLabel
onready var timeLabel: Label = $CanvasLayer/Control/TimeLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	set_values()
	
func _physics_process(delta):
	set_values()

func set_values():
	characterNameLabel.text	= PlayerData.characterName
	scoreLabel.text	= String(PlayerData.score).pad_zeros(7)
	coinsLabel.text	= String(PlayerData.coins).pad_zeros(2)
	worldLevelLabel.text	= String(PlayerData.current_world) + "-" + String(PlayerData.current_level)
	if(PlayerData.timeLimitTimer):
		timeLabel.text	= String(int(PlayerData.timeLimitTimer.time_left))
