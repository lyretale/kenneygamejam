extends KinematicBody2D

onready var aggro_area := $AggroArea
var target: KinematicBody2D

export var max_speed := 250.0
export var drag_factor := 0.1

var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO

func _ready() -> void:
	aggro_area.connect("body_entered", self, "_on_player_entered")
	aggro_area.connect("body_exited", self, "_on_player_exited")
	
func _on_player_entered(player: KinematicBody2D) -> void:
	# Sets the target to the robot when it enters the Area2D.
	target = player


func _on_player_exited(robot: KinematicBody2D) -> void:
	# When the robot exits the Area2D, the target is out of range.
	target = null

func _physics_process(delta: float) -> void:
	# We start by calculating the bat's movement direction.
	var direction := Vector2.ZERO
	
	if target:
		direction = to_local(target.global_position).normalized()


	var desired_velocity := max_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor

	velocity = move_and_slide(velocity)

	if direction:
		rotation = velocity.angle()
