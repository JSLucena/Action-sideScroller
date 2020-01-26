extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 300
export var sprint_speed = 300
export var falling_speed = 50
export var max_fall_speed = 800
export var jump = -800
var side = "right"
var is_jumping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


