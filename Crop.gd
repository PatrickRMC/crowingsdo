extends Area2D

var can_harvest = false
var harvested = false
var speed = 250
var direction = 1
var sounds = ["noo","nono"]
var taken = false
var nums = []
export var bad : bool
func _ready():
	add_to_group("crop")
	nums = [-1,1] #list to choose from
	direction = nums[randi() % nums.size()]
	speed = rand_range(150,300)
	$AnimatedSprite.play("growing")
	$AnimationPlayer.play("idle")
	

func _process(delta):
	if taken:
		taken = false
		if direction == -1:
			$noo.play()
		else:
			$nono.play()
	if not can_harvest or harvested:
		return
	$AnimatedSprite.scale.x = -direction
	position.x += speed * direction * delta
		

func _on_AnimatedSprite_animation_finished():
	if can_harvest == false:
		$pop.play()
	$AnimatedSprite.play("run")
	$AnimationPlayer.play("running")
	can_harvest = true


func _on_Crop_area_entered(area):
	if area.is_in_group("edgecol"):
		direction = -direction
