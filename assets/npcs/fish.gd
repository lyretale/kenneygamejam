extends KinematicBody2D

onready var timer := $Timer

export var move_speed := 30

var move_direction := Vector2.ZERO

func _ready() -> void:
	select_new_direction()
	timer.connect("timeout", self, "_on_Timeout")

func _physics_process(_delta):
	var velocity = move_direction * move_speed
	var direction = move_direction
	
	if direction:
		rotation = velocity.angle()
		
	move_and_slide(velocity)
	
func select_new_direction() -> void:
	move_direction = Vector2(rand_range(-1,1), rand_range(-1,1))
	
func _on_Timeout() -> void:
		select_new_direction()
