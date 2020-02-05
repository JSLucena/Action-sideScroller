extends KinematicBody2D

export var speed = 300
export var falling_speed = 200
export var max_fall_speed = 1000
export var jump = -600
export var max_health = 2000
onready var cur_health = max_health

var velocity = Vector2(0,0)


func _ready():
	
	$HPBar.update_max_health(max_health)
	$HPBar.update_health(cur_health, cur_health)
	$HPBar.set_min_health()
	pass 


func isOnFloor():
	return $Godot.get_node("floorCollision1").is_colliding() or $Godot.get_node("floorCollision2").is_colliding() or $Godot.get_node("floorCollision3").is_colliding()

func apply_gravity(count, value):
	velocity.y = velocity.y + $Godot.falling_speed * value * count
	if velocity.y > $Godot.max_fall_speed:
		velocity.y = $Godot.max_fall_speed

func take_damage(damage):
	var old_health = cur_health
	if(cur_health > 0):
		cur_health -= damage
		$HPBar.update_health(cur_health,old_health)


