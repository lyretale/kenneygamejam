extends Area2D

export var player_stats: Resource = null

onready var animation_player := $AnimationPlayer
onready var timer := $Timer
onready var send_timer := $SendTimer
onready var objective_area := $ObjectiveCollision

signal update_time(new_time)
signal update_score_objective(new_score)
signal update_objective

func _ready() -> void:
	timer.connect("timeout", self, "time_ran_out")
	send_timer.connect("timeout", self, "send_time")
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

func set_player_stats(stats) -> void:
	player_stats = stats

func set_time(time) -> void:
	timer.wait_time = time
	timer.start()

func send_time() -> void:
	emit_signal("update_time", int(round(timer.time_left)))

func trigger_delivery_point() -> void:
	player_stats.score = 30
	emit_signal("update_score_objective", player_stats.score)
	emit_signal("update_objective")
	queue_free()
