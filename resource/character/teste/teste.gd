extends KinematicBody2D


export var speed = 300
export var sprint_speed = 300
export var falling_speed = 50
export var max_fall_speed = 800
export var jump = -600
export var damage = 100
export var max_health = 500
onready var cur_health = max_health



signal hit(body)

func _ready():
	$HPBar.update_max_health(max_health)
	$HPBar.update_health(cur_health, cur_health)
	$HPBar.set_min_health()
	pass 





func _on_hitBox_body_entered(body):
	emit_signal("hit",body)

