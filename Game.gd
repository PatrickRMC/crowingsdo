extends Node2D

var crop = null
var cropspawns = []
onready var crop_scene = preload("res://Crop.tscn")
onready var scarecrow_scene = preload("res://ScareCrow.tscn")

var hearts = []

func _ready():
	GLOBALS.score = 0
	GLOBALS.hp = 5
	$CanvasLayer.visible = false
	cropspawns = $Cropspawns.get_children()
	hearts = $Control/HeartsContainer.get_children()

func _physics_process(delta):
	if GLOBALS.hp <= 0:
		for i in hearts.size():
			hearts[i].visible = false
		$CanvasLayer.visible = true
		$Timer.paused = true
		$Crow.visible = false
		$CanvasLayer/Gameover/Label.text = $Control/scorelabel.text
		return
	$Control/scorelabel.text = '%07d' % GLOBALS.score
	for i in hearts.size():
		hearts[i].visible = false
	for i in GLOBALS.hp:
		hearts[i].visible = true
	$Control/AnimationPlayer.play("hearts")


func _on_Timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randi_range(0,2) != 0:
		crop = crop_scene.instance()
	else:
		crop = scarecrow_scene.instance()
	add_child(crop)
	crop.global_position = cropspawns[rng.randi_range(0,cropspawns.size()-1)].global_position


func _on_menu2_pressed():
	get_tree().reload_current_scene()
