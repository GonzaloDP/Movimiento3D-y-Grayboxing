extends Node3D

@onready var player = $"."

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.aumentar_moneda()
	queue_free()
