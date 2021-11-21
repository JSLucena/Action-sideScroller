extends KinematicBody2D


export var speed = 300
export var falling_speed = 200
export var max_fall_speed = 1000
export var jump = -600
export var max_health = 2000
onready var cur_health = max_health

#var player_is_in_range = false
#var player_in_range = Vector2(0,0)
#var player_body

#var velocity = Vector2(0,0)

signal dead()


func _ready():
	$HPBar.update_max_health(max_health)
	$HPBar.update_health(cur_health, cur_health)
	$HPBar.set_min_health()
	self.connect("dead", self , "_on_death")
	
func take_damage(damage):
	var old_health = cur_health
	if(cur_health > 0):
		cur_health -= damage
		$HPBar.update_health(cur_health,old_health)
	if(cur_health <= 0):
		emit_signal("dead")
		
func _on_death():
	$HPBar.update_health(max_health,max_health)
	cur_health = max_health
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
