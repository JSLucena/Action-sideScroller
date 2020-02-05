extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 300
export var sprint_speed = 300
export var falling_speed = 50
export var max_fall_speed = 800
export var jump = -800
export var damage = 20
export var max_health = 500
onready var cur_health = max_health

var side = "right"
var is_jumping = false

signal hit(body)

func _ready():
	pass 





func _on_hitBox_body_entered(body):
	emit_signal("hit",body)
