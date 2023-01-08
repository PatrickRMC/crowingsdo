extends Area2D

var speed = 400
var crop_grabbed = null
var dive = false
func _ready():
	$AnimationPlayer.play("fly")

func _physics_process(delta):
	if dive or GLOBALS.hp <= 0:
		return
	var x_input = Input.get_action_raw_strength("left") - Input.get_action_raw_strength("right")
	
	position.x += x_input * -speed * delta
	
	if position.x > 1200:
		position.x = 0
	if position.x < -100:
		position.x = 1100
	
	if x_input != 0:
		$AnimatedSprite.scale.x = x_input
		
	if Input.is_action_just_pressed("dive"):
		dive = true
		$AnimationPlayer.play("dive")
		$dive.play()

func _on_Crow_area_entered(area):
	if area.is_in_group("crop"):
		if crop_grabbed == null:
			crop_grabbed = area
			crop_grabbed.taken = true
			crop_grabbed.get_parent().remove_child(crop_grabbed)
			$AnimatedSprite.add_child(crop_grabbed)
			crop_grabbed.position = Vector2.ZERO
			crop_grabbed.scale = Vector2.ONE
			crop_grabbed.harvested = true

func _hit(x):
	GLOBALS.hp -= x
	$ow.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "dive":
		dive = false
		$AnimationPlayer.play("fly")
		if crop_grabbed != null:				
			$nomnomnom.play()
			if crop_grabbed.bad:
				_hit(1)
			else:
				GLOBALS.score += 150
			crop_grabbed.queue_free()
			crop_grabbed = null
