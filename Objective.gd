extends Area2D

export var player_stats: Resource = null

onready var animation_player := $AnimationPlayer
onready var timer := $Timer
onready var objective_area := $ObjectiveCollision

onready var animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:
	timer.connect("timeout", self, "time_ran_out")
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		timer.stop()
		animation_player.play("occupied")

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		animation_player.play_backwards("occupied")

func start() -> void:
	# print objective started
	pass

func time_ran_out() -> void:
	# print objective failed
	pass

func trigger_delivery_point() -> void:
	# spawn del point
	queue_free()
