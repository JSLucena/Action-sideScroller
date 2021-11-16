extends KinematicBody2D

export var speed = 300
export var falling_speed = 200
export var max_fall_speed = 1000
export var jump = -600
export var max_health = 2000
onready var cur_health = max_health

var player_is_in_range = false
var player_in_range = Vector2(0,0)
var player_body

var velocity = Vector2(0,0)


func _ready():
	
	$HPBar.update_max_health(max_health)
	$HPBar.update_health(cur_health, cur_health)
	$HPBar.set_min_health()
	pass 


func isOnFloor():
	return $Godot.get_node("floorCollision1").is_colliding() or $Godot.get_node("floorCollision2").is_colliding() or $Godot.get_node("floorCollision3").is_colliding()

func apply_gravity(count, value):
	velocity.y = velocity.y + falling_speed * value * count
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

func take_damage(damage):
	var old_health = cur_health
	if(cur_health > 0):
		cur_health -= damage
		$HPBar.update_health(cur_health,old_health)

func apply_movement(chase_direction):
	if chase_direction == "left":
		velocity.x = -speed
	elif chase_direction == "right":
		velocity.x = speed
	velocity.y = jump

func find_player_pos(area):
	player_in_range = area.get_global_position()
	#print(area.get_global_position())
	




func _on_Detection_area_entered(area):
	player_is_in_range = true
	player_body = area
	print(true)
	pass # Replace with function body.


func _on_Detection_area_exited(area):
	player_is_in_range = false
	player_body = area
	print(false)
	pass # Replace with function body.
