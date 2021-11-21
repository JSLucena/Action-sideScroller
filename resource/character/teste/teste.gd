extends KinematicBody2D


export var speed = 300
export var sprint_speed = 300
export var falling_speed = 50
export var max_fall_speed = 800
export var jump = -600
export var damage = 100
export var max_health = 500
onready var cur_health = max_health


export var hp_x_scale = 0.7
export var hp_y_scale = 0.7

signal hit(body)

func _ready():
	$HPBar.update_max_health(max_health)
	$HPBar.update_health(cur_health, cur_health)
	$HPBar.set_min_health()
	resize_hp_bar()
	pass 

func resize_hp_bar():
	$HPBar.rect_scale = Vector2(hp_x_scale,hp_y_scale)
	$HPBar.rect_global_position = $HPBar.get_global_position() * Vector2(hp_x_scale,hp_y_scale)
	self.get_node("HPBar").get_node("curHP").rect_scale = Vector2(hp_x_scale*2,hp_y_scale*2)
	pass




func _on_hitbox_area_entered(body):
	print("HIT")
	emit_signal("hit",body)
	pass # Replace with function body.

