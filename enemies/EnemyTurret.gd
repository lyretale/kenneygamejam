extends Area2D

export (float, 0.01, 1.0) var rotation_factor := 0.1
export (NodePath) var target_path
export (NodePath) var bullets_path

onready var target_node = get_node(target_path)
onready var bullets_node = get_node(bullets_path)
onready var start_offset = self.transform.origin - target_node.transform.origin

onready var timer := $Timer
onready var cannon := $Sprite/Position2D
onready var sprite := $Sprite

var target: PhysicsBody2D = null
var target_list := []

func _ready() -> void:
	# We use the timer to control the rate of fire. By default, timers run
	# continuously and emit their timeout signal periodically.
	timer.connect("timeout", self, "_on_Timer_timeout")
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _process(delta):
	self.transform.origin = target_node.transform.origin + start_offset

func _physics_process(_delta: float) -> void:
	_rotate_to_target()

func _rotate_to_target() -> void:
	var target_angle := PI / 2
	if target:
		target_angle = target.global_position.angle_to_point(global_position)
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)

func _on_Timer_timeout() -> void:
	# If there are no targets in the target_list array, we stop the function and
	# skip firing a rocket.
	if not target_list:
		return
	# We load the rockt scene and instantiate it.
	var cannon_ball: Area2D = preload("../CannonBall.tscn").instance()
	bullets_node.add_child(cannon_ball)
	# This line copies the `cannon`'s position, rotation, and scale at once,
	# placing and orienting the rocket properly.
	cannon_ball.global_transform = cannon.global_transform

func select_target() -> void:
	if target_list:
		target = target_list[0]
	else:
		target = null

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body and body.is_in_group("player"):
		target_list.append(body)
		select_target()

func _on_body_exited(body: PhysicsBody2D) -> void:
	if body and body.is_in_group("player"):
		var index := target_list.find(body)
		target_list.remove(index)
		select_target()


