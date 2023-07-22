extends KinematicBody2D

# Will store the robot when it enters the Area2D.
var target: KinematicBody2D

# The Area2D that detects the player.
onready var aggro_area := $AggroArea

export var max_speed := 400.0
export var drag_factor := 0.1

var velocity := Vector2.ZERO
var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO
var direction := Vector2.ZERO
var angle = 0
var radius = 50


func _ready() -> void:
	aggro_area.connect("body_entered", self, "_on_player_entered")
	aggro_area.connect("body_exited", self, "_on_player_exited")

func _physics_process(delta: float) -> void:
	direction = Vector2(0,0)
	if target:
		direction = to_local(target.global_position).normalized() #+ Vector2.RIGHT.rotated(angle)*radius
		#angle += 0.5
		

	desired_velocity = max_speed * direction
	steering_vector = desired_velocity - velocity
	velocity += steering_vector * drag_factor 
	
	position += move_and_slide(velocity * delta)
	
	rotation = velocity.angle()
	

func _on_player_entered(body: KinematicBody2D) -> void:
	# Sets the target when it enters the Area2D.
	if body.is_in_group("player"):
		target = body


func _on_player_exited(body: KinematicBody2D) -> void:
	# When player exits the Area2D, the target is out of range.
	if body.is_in_group("player"):
		target = null
